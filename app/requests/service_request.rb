class ServiceRequest

    def self.check_service

        service_logger = ServiceLogger.new

        service_logger
        
    end

    def self.confirm_service service

        service_logger = ServiceLogger.new
        uri = URI.parse(service.gate_host)
        params = {method: 'confirm', hashed_token: Digest::MD5.hexdigest(service.token)}
        begin 
            response = Net::HTTP.post_form(uri, params)
        rescue StandardError => e
            service_logger.append "Invalid connection"
        end
        service_logger.append "Invalid status" if service_logger.ok? && response.code != '200'
        service_logger.append "Invalid token" if service_logger.ok? && JSON.parse(response.body)['token'] != service_registration.token

        if service_logger.ok?
            service.status = Service.statuses[:confirmed]
            service.save
            ServiceManager.call_updating_job
        else 
            ServiceManager.drop_service service
        end
        service_logger

    end

    def self.update_service

        service_logger = ServiceLogger.new

        service_logger

    end
end