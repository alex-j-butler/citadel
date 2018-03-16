Datadog.configure do |c|
  c.tracer env: Rails.env
end
