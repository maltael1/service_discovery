require 'uri'
require 'net/http'

class ServiceConfirmJob < ApplicationJob
  
  queue_as :default

  def perform service

    ServiceManager.confirm_service service

  end

end
