require 'pg'
require 'concurrent/atomics'

module PGQueryTime
  module Instrumented
    def exec(*args)
      start = Time.now
      super(*args)
    ensure
      duration = (Time.now - start)
      ::PG::Connection.query_time.update { |value| value + duration }
      ::PG::Connection.query_count.update { |value| value + 1 }
    end

    def async_exec(*args)
      start = Time.now
      super(*args)
    ensure
      duration = (Time.now - start)
      ::PG::Connection.query_time.update { |value| value + duration }
      ::PG::Connection.query_count.update { |value| value + 1 }
    end

    def exec_prepared(*args)
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
    attr_accessor :query_time, :query_count
  end

  self.query_time = Concurrent::AtomicReference.new(0)
  self.query_count = Concurrent::AtomicReference.new(0)
end

module AdminBar
  module Views
    class PG < View
      def setup_subscribers
        before_request do
          # Reset Postgres query data.
          ::PG::Connection.query_time.value = 0
          ::PG::Connection.query_count.value = 0
        end
      end

      def results
        { calls: query_calls, duration: query_duration }
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
