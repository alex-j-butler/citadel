module AdminBar
  def self._request_id
    @_request_id ||= Concurrent::AtomicReference.new
  end

  def self.request_id
    _request_id.get
  end

  def self.request_id=(id)
    _request_id.update { id }
  end

  def self.env
    Rails.env
  end

  def self.results
    results = {
      data: Hash.new { |h, k| h[k] = {} }
    }

    views.each do |view|
      view.results.each do |key, value|
        results[:data][view.key][key] = value
      end
    end

    results
  end

  def self.views
    @view_instances ||= @views.collect { |klass, options| klass.new(options.dup) }
  end

  def self.add(klass, options = {})
    @views ||= []
    @views << [klass, options]
  end

  def self.reset
    @views = nil
  end

  def self.get(request_id)
    @requests ||= {}
    @requests[request_id]
  end

  def self.save
    @requests ||= {}
    @requests[request_id] = results
  end

  def self.clear
    _request_id.update { '' }
  end
end
