module AdminHelper
  def leagues
    League.all
  end

  def pg_query_time
  	::PG::Connection.query_time.value 
  end

  def pg_query_calls
    ::PG::Connection.query_count.value
  end

  def pg_query_duration
    ms = pg_query_time * 1000
    if ms >= 1000
      "%.2fms" % ms
    else
      "%.0fms" % ms
    end
  end
end
