class V0::ApiController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authorize_by_service, only: [:register_service]

    def register_service
        @service = ServiceManager.register_service(@service_variant, params[:host], params[:gate_host])
        if @service.valid?
            render json: {token: @service.token}
        else
            render json: {
                errors: @service.errors.messages
            }, status: 409
        end
    end

    private 

    def authorize_by_service

        return render json: {errors: {arguemnts: "Method register service must constrain 'token', 'host' and 'gate_host' params"}}, status: 400 if params[:token].nil? || params[:host].nil? || params[:gate_host].nil?
        @service_variant = ServiceVariant.find_by(token: params[:token])
        return render json: {errors: {token: "Invalid token"}}, status: 403 if @service_variant.nil?
    end
end
