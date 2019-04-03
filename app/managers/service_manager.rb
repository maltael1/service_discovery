class ServiceManager

    def self.register_service service_variant, host, gate_host

        service = service_variant.services.innactive.find_by host: host, gate_host: gate_host
        service = service_variant.services.build host: host, gate_host: gate_host if service.nil?
        service.init_token
        ServiceConfirmJob.set(wait: 3.seconds).perform_later(service) if service.save
        service

    end

    def self.drop_service service

        service.status = Service.statuses[:lost]
        service.save

    end

    def self.confirm_service service

        service_logger = ServiceRequest.confirm_service(service)
        if service_logger.ok?
            service.status = Service.statuses[:confirm]
            service.save
        end
        service_logger

    end

    def self.check_service service

        service_logger = ServiceRequest.check_service service
        if !service_logger.ok?
            ServiceManager.drop_service service
        end
        service_logger

    end

    def self.update_service service

        service_logger = ServiceRequest.update_service service
        if !service_logger.ok?
            ServiceManager.drop_service service
        end
        service_logger
    end

    def self.check_all_services

        check_failture = false
        Service.active.each do |service|
            check_failture = true if !ServiceManager.check_service(service).ok?
        end
        ServiceManager.update_all_services if check_failture
        
    end

    def self.update_all_services
        
        update_failture = false
        Service.active.each do |service|
            update_failture = true if !ServiceManager.update_service(service).ok?
        end
        ServiceManager.update_all_service if update_failture

    end
end