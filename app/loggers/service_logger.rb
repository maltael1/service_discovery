class ServiceLogger

    attr_accessor :errors

    def append param
        @errors = [] if errors.nil? 
        @errors << param
    end

    def ok?
        @errors.nil?
    end
end