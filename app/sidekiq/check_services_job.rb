class CheckServicesJob
  include Sidekiq::Job

  def perform(*args)
    Service.find_each do |service|
      check_service_status(service)
    end
  end

  private

  # FIXME: adjust this method to check the service status, not just the response
  def check_service_status(service)
    uri = URI.parse(service.url)

    begin
      response = Net::HTTP.get_response(uri)
      service_status = response.is_a?(Net::HTTPSuccess)

      puts response
    rescue
      service_status = false
    end

    if service_status != service.is_healthy
      service.update(is_healthy: service_status)
    end

    puts "Service #{service.name} is #{service_status ? 'up' : 'down'}"
  end
end
