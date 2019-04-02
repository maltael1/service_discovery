class V0::ApiController < ApplicationController

    skip_before_action :verify_authenticity_token
    before_action :authorize_by_service, only: [:register_service]

    def service_list

    end

    # Запрос регистрации сервиса (должен выполнятсья при инициализации сервиса)
    # При успешном выполнении будет зарегистрирован сервис и присвоен токен, который вернётся в ответе
    # Статус 200, тело: {'token' => '1234567890'}
    #
    # POST http://{service_provider_domain}/api/v0/register_service
    # headers = {'Content-Type' => 'application/json'}
    # params = {
    #     'token' => '43fb8a9e06765aea96377f71fbc3f5b5', 
    #     'host' => 'http://localhost:2000' , 
    #     'gate_host' => 'http://localhost:2000' 
    # }
    #
    # @token - Токен регистрации сервиса, 43fb8a9e06765aea96377f71fbc3f5b5 - авторизоваться как сервис авторизации
    # @host - хост, на который будут посылать запросы другие сервисы
    # @gate_host - url, на который будет отправлен POST запрос для проверки доступности сервиса
    #
    # При отсутсвии одного из параметров возвращает 400 статус и тело 
    # {'errors' => {'arguments' => 'Method register service must constrain 'token', 'host' and 'gate_host' params'}}
    #
    # При некорректном токене возвращает 403 статус и тело
    # {'errors' => {'token' => 'Invalid token'}}
    #
    # При некорректых host и gate_host (допускаются только с http:// или https://) возвращает 409 и тело
    # {'errors' => {'gate_host' => 'is not a valid HTTP URL', 'host' => 'is not a valid HTTP URL'}}
    #
    # Присутсвует валидация уникальности host и gate_host в случае существование подтверждённого сервиса.
    # Если в системе уже есть подтверждённый сервис с хостом http://example.com и поступит POST запрос с host = http://example.com,
    # то ответ будет следующим: 409, {'errors' => {'host' => 'Service already confirmed'}}

    def register_service
        @registed_service = ServiceManager.register_service(@service, params[:host], params[:gate_host])
        if @registed_service.valid?
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
