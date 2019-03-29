class ServiceManager

    def self.register_service service, host, gate_host

        service_registration = find_inactive_service_registration service, host, gate_host
        service_registration = register_inactive_service_registration service, host, gate_host if service_registration.nil?
        service_registration.init_token
        call_confirmation_job service_registration if service_registration.save
        return service_registration

    end

    def self.drop_service service_registration, with_call_job: true
        service_registration.status = ServiceRegistration.statuses[:lost]
        service_registration.save
        call_updating_job if with_call_job
    end

    def self.confirm_service service_registration
        service_registration.status = ServiceRegistration.statuses[:confirmed]
        service_registration.save
    end

    def self.active_registrations
        result = []
        Service.all.each do |service|
            result[] = service.service_registrations.confirmed.first.host if service.service_registrations.confirmed.first.present?
        end
        result
    end

    def self.hosts_by_code
        json = {}
        active_registrations.each do |service_registration|
            json[service_registration.service.code] = service_registration.host
        end
        json
    end

    private 

    def self.find_inactive_service_registration service, host, gate_host
        service.service_registrations.where(
            host: host, 
            gate_host: gate_host
        ).where.not(status: ServiceRegistration.statuses[:confirmed]).first
    end

    def self.register_inactive_service_registration service, host, gate_host
        service.service_registrations.build(
            host: host,
            gate_host: gate_host,
            status: ServiceRegistration.statuses[:registred]
        )
    end

    def self.call_confirmation_job service_registration
        ServiceConfirmJob.set(wait: 10.seconds).perform_later(service_registration)
    end

    def self.call_updating_job
        ServiceUpdateJob.set(wait: 10.seconds).perform_later
    end

end