class Result

    attr_accessor :errors

    def fail param
        @errors = [] if errors.nil? 
        @errors << param
    end

    def ok?
        @errors.nil?
    end

    def message
        @errors.last
    end
end