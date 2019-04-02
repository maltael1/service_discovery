require 'uri'
require 'net/http'

class ServiceConfirmJob < ApplicationJob
  queue_as :default

    # Сервис - провайдер отправляет запрос для подтверждения сервиса
    #
    # POST {gate_host}
    # headers = {'Content-Type' => 'application/json'}
    # params = {
    #     'method' => 'confirm', 
    #     'hashed_token' => MD5(token)
    # }
    #
    # @method - тип запроса, confirm - запрос на подтверждение, update - запрос на обновления хостов
    # @hashed_token - md5 от токена, который был возвращён в запросе регистрации сервиса 
    # (требуется для проверки достоверности провайдер-сервиса)
    # @token - токен, который был возвращён в запросе регистрации сервиса
    #
    # В ответе ожидается статус 200 и тело {'token' => {token}} 
    # (Требуется для подтверждения что сервис обработал ответ при регистрации сервиса)
    #
    # Присутсвует валидация уникальности host и gate_host в случае существование подтверждённого сервиса.
    # Если в системе уже есть подтверждённый сервис с хостом http://example.com и поступит POST запрос с host = http://example.com,
    # то ответ будет следующим: 409, {'errors' => {'host' => 'Service already confirmed'}}

  def perform(service_registration)

    uri = URI.parse(service_registration.gate_host)
    params = {method: 'confirm', hashed_token: Digest::MD5.hexdigest(service_registration.token)}
    begin 
      response = Net::HTTP.post_form(uri, params)
    rescue Errno::ECONNREFUSED => e
      connection_error = true
    end

    if !connection_error && response.code == '200' && JSON.parse(response.body)['token'] == service_registration.token
      service_registration.status = ServiceRegistration.statuses[:confirmed]
      service_registration.save
      ServiceManager.call_updating_job
    else 
      ServiceManager.drop_service service_registration,  with_call_job: false
    end

  end
end
