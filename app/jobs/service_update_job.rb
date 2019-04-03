require 'uri'
require 'net/http'

class ServiceUpdateJob < ApplicationJob

  queue_as :default

  def perform service

    ServiceManager.update_job service

  end
  
end
