require 'uri'
require 'net/http'

class ServiceConfirmJob < ApplicationJob
  queue_as :default

  def perform(service_registration)


    uri = URI.parse(service_registration.gate_host)
    params = {method: 'confirm', hashed_token: Digest::MD5.hexdigest(service_registration.token)}
    response = Net::HTTP.post_form(uri, params)

    if response.code == '200' && JSON.parse(response.body)['token'] == service_registration.token
      service_registration.status = ServiceRegistration.statuses[:confirmed]
      service_registration.save
      ServiceManager.call_updating_job
    else 
      ServiceManager.drop_service service_registration,  with_call_job: false
    end

  end
end
