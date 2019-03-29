require 'uri'
require 'net/http'

class ServiceUpdateJob < ApplicationJob
  queue_as :default

  def perform
    params = {method: 'update', services: hosts_by_code}
    ServiceManager.active_registrations.each do |service_registration|
        one_service_returned_false = true if Net::HTTP.post_form(URI.parse(service_registration.gate_host), params).code != '200'
            ServiceManager.drop_service(service_registration, with_call_job: false)
        end
    end

    ServiceManager.call_updating_job if one_service_returned_false

  end
end
