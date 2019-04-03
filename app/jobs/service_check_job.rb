require 'uri'
require 'net/http'

class ServiceCheckJob < ApplicationJob
  
  queue_as :default

  def perform(service)

    ServiceManager.check_service service

  end
  
end
