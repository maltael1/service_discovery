require 'uri'
require 'net/http'

class ServiceConfirmJob < ApplicationJob
  queue_as :default

  def perform(service_registration)

    uri = URI.parse(service_registration.gate_host)
    params = {method: 'confirm', hashed_token: Digest::MD5.hexdigest(service_registration.token)}
    begin 
      response = Net::HTTP.post_form(uri, params)
    rescue Errno::ECONNREFUSED => e
      connection_error = true
    end

    if !connection_error && response.code == '200' && JSON.parse(response.body)['token'] == service_registration.token
      service_registration.status = ServiceRegistration.statuses[:confirmed]
      service_registration.save
      ServiceManager.call_updating_job
    else 
      ServiceManager.drop_service service_registration,  with_call_job: false
    end

  end
end
