class ServiceManager

    def self.register_service service_variant, host, gate_host

        service = service_variant.services.innactive.find_by host: host, gate_host: gate_host
        service = service_variant.services.build host: host, gate_host: gate_host if service.nil?
        service.init_token
        if service.valid?
            service.logs.build status: Log.statuses[:ok], message: 'Service was registred'
            service.save
            ServiceConfirmJob.set(wait: 3.seconds).perform_later(service)
        end
        service

    end

    def self.drop_service service

        it_was_active_service = service.status == 'activated'
        service.status = Service.statuses[:lost]
        service.logs.build status: Log.statuses[:warning], message: 'Service was dropped'
        service.save
        ServiceManager.activate_service service.service_variant if it_was_active_service

    end

    def self.confirm_service service

        result = ServiceRequest.confirm_service(service)
        if result.ok?
            service.status = Service.statuses[:confirmed]
            service.logs.build status: Log.statuses[:ok], message: 'Service was confirmed'
        else 
            service.status = Service.statuses[:lost]
            service.logs.build status: Log.statuses[:error], message: "Service was't confirmed: #{result.message}"
        end
        service.save
        ServiceManager.activate_service(service.service_variant) if result.ok?
        result

    end

    def self.check_service service

        result = ServiceRequest.check_service service
        if !result.ok?
            service.logs.create status: Log.statuses[:error], message: "Service checking error: #{result.message}"
            ServiceManager.drop_service service
        end
        result

    end

    def self.activate_service service_variant
        result = Result.new
        activated_service = service_variant.services.active.first
        last_confirmed_service = service_variant.services.confirmed.last
        if activated_service.present?
            result.fail "One activated service already present, it service with id: #{activated_service.id}"
        elsif last_confirmed_service.nil?
            result.fail "No confirmed service"
            service_variant.logs.create status: Log.statuses[:error], message: "Service activation error: #{result.message}"
        else
            last_confirmed_service.status = Service.statuses[:activated]
            last_confirmed_service.logs.build status: Log.statuses[:ok], message: "Service was activated"
            last_confirmed_service.save
            ServiceManager.update_all_services
        end
        result

    end

    def self.update_service service

        result = ServiceRequest.update_service service
        if !result.ok?
            service.logs.create status: Log.statuses[:error], message: "Service updating error: #{result.message}"
            ServiceManager.drop_service service
        else
            service.logs.create status: Log.statuses[:ok], message: "Service was updated"
        end
        result
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
        ServiceManager.update_all_services if update_failture

    end

end