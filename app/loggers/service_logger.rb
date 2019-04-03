class ServiceLogger

    @errors = {}

    def errors
        @errors
    end

    def ok?
        @errors.empty?
    end
end