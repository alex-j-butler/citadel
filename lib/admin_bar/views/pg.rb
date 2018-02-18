require 'pg'
require 'concurrent/atomics'

module PGQueryTime
  module Instrumented
    def exec(*args)
      ::PG::Connection.queries.update { |value| value << { method: :exec, sql: args[0] } }
      start = Time.now
      super(*args)
    ensure
      duration = (Time.now - start)
      ::PG::Connection.query_time.update { |value| value + duration }
      ::PG::Connection.query_count.update { |value| value + 1 }
    end

    def async_exec(*args)
      ::PG::Connection.queries.update { |value| value << { method: :async_exec, sql: args[0] } }
      start = Time.now
      super(*args)
    ensure
      duration = (Time.now - start)
      ::PG::Connection.query_time.update { |value| value + duration }
      ::PG::Connection.query_count.update { |value| value + 1 }
    end

    def exec_prepared(*args)
      ::PG::Connection.queries.update { |value| value << { method: :exec_prepared, statement_name: args[0] } }
      start = Time.now
      super(*args)
    ensure
      duration = (Time.now - start)
      ::PG::Connection.query_time.update { |value| value + duration }
      ::PG::Connection.query_count.update { |value| value + 1 }
    end
  end
end

class PG::Connection
  prepend PGQueryTime::Instrumented

  class << self
    attr_accessor :query_time, :query_count, :queries
  end

  self.queries = Concurrent::AtomicReference.new([])
  self.query_time = Concurrent::AtomicReference.new(0)
  self.query_count = Concurrent::AtomicReference.new(0)
end

module AdminBar
  module Views
    class PG < View
      def setup_subscribers
        before_request do
          # Reset Postgres query data.
          ::PG::Connection.queries.value = []
          ::PG::Connection.query_time.value = 0
          ::PG::Connection.query_count.value = 0
        end
      end

      def results
        { queries: queries, raw_queries: raw_queries, calls: query_calls, duration: query_duration }
      end

      def raw_queries
        ::PG::Connection.queries.value
      end

      def queries
        q = ::PG::Connection.queries.value.select{ |val| val[:method] == :async_exec && val[:sql] }.map{ |val| val[:sql] }
        q.group_by(&:to_s).map { |a| {query: a[0], count: a[1].count} }
      end

      def query_time
        ::PG::Connection.query_time.value 
      end

      def query_calls
        ::PG::Connection.query_count.value
      end

      def query_duration
        ms = query_time * 1000
        "%.2fms" % ms
      end
    end
  end
end
