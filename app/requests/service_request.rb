class ServiceRequest

    def self.check_service service

        result = Result.new
        uri = URI.parse(service.gate_host)
        params = {method: 'check'}
        begin 
            response = Net::HTTP.post_form(uri, params)
        rescue StandardError => e
            result.fail "Invalid connection to '#{service.gate_host}'"
        end
        result.fail "Invalid status response (#{response.code})" if result.ok? && response.code != '200'
        result
        
    end

    def self.confirm_service service

        result = Result.new
        uri = URI.parse(service.gate_host)
        params = {method: 'confirm', hashed_token: Digest::MD5.hexdigest(service.token)}
        begin 
            response = Net::HTTP.post_form(uri, params)
        rescue StandardError => e
            result.fail "Invalid connection to '#{service.gate_host}'"
        end
        result.fail "Invalid status response (#{response.code})" if result.ok? && response.code != '200'
        result.fail "Invalid token" if result.ok? && JSON.parse(response.body)['token'] != service.token
        result

    end

    def self.update_service service

        result = Result.new
        uri = URI.parse(service.gate_host)
        params = {method: 'update', services: Service.hosts_by_code}
        begin 
            response = Net::HTTP.post_form(uri, params)
        rescue StandardError => e
            result.fail "Invalid connection to '#{service.gate_host}'"
        end
        result.fail "Invalid status response (#{response.code})" if result.ok? && response.code != '200'
        result

    end
end