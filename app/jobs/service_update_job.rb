require 'uri'
require 'net/http'

class ServiceUpdateJob < ApplicationJob
  queue_as :default

    # Сервис - провайдер отправляет запросы на все подтверждённые сервисы с обновлением информации об активных сервисах
    #
    # POST {gate_host}
    # headers = {'Content-Type' => 'application/json'}
    # params = {
    #     'method' => 'update',
    #     'services' => {
    #       'auth' => 'http://example.com',
    #       'rest_api' => 'http://example2.com',
    #       'geocalc' => 'http://example3.com',
    #       'admin' => 'http://example3.com'
    #     }
    # }
    #
    # @method - тип запроса, confirm - запрос на подтверждение, update - запрос на обновления хостов
    #
    # В ответе ожидается статус 200 
    #
    # Если сервис не вернёт 200 статус - от будет отключён, 
    # далее будет повторно вызван метод обновления информации по всем оставшимся сервисам

  def perform
    one_service_returned_false = false
    params = {method: 'update', services: ServiceManager.hosts_by_code}
    ServiceManager.active_registrations.each do |service_registration|
      if Net::HTTP.post_form(URI.parse(service_registration.gate_host), params).code != '200'
        one_service_returned_false = true
        ServiceManager.drop_service(service_registration, with_call_job: false)
      end
    end

    ServiceManager.call_updating_job if one_service_returned_false

  end
end
