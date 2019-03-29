class V0::ApiController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authorize_by_service, only: [:register_service]

    def service_list

    end

    def register_service
        @registed_service = @service.register_service(host: params[:host], gate_host: params[:gate_host])
        if @registed_service.save
            render json: {token: @registed_service.token}
        else
            render json: {
                errors: @registed_service.errors.messages
            }, status: 409
        end
    end

    private 

    def authorize_by_service

        return render json: {errors: {arguemnts: "Method register service must constrain 'token', 'host' and 'gate_host' params"}}, status: 400 if params[:token].nil? || params[:host].nil? || params[:gate_host].nil?
        @service = Service.find_by(token: params[:token])
        return render json: {errors: {token: "Invalid token"}}, status: 403 if @service.nil?
    end
end
