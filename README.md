<h1>Service discovery</h1>
<h2>Этапы взаимодействия сервисов</h2>
<ul>
  <li>
   Формирование токена конфигурации
    <br>
    Servcice Discovery формирует и подписывает JWT токен (@configuratuin_token) следующего формата:
    {name: @service_name, provider_host: @provider_host, permissions: ['auth', 'geo']}
    @service_name - тип сервиса, по которому будут обращаться другие микросервисы, прим: 'auth', 'geo'
    @provider_host - url провайдер сервиса
    @permissions - массив из @service_name, к которым микросервис имеет право отправлять запросы
    Далее токен передаётся в качестве секрета в конфиги микросервиса
  </li>
  <li>
  Регистрация микросервиса
  <br>
    Микросервис формирует и подписывает JWT токен (@service_token) следующего формата:
    {host: @host, gate_host: @gate_host, configuration_token: @configuration_token}
    host - url микросервиса, на который будут стучаться другие микросервисы
    gate_host - url микросервиса, на который будет стучаться провайдер
    configuration_token - токен определения роли микросервиса
    <br><br>
    Микросервис формирует POST запрос на адрес url провайдера со следующим телом:
    {token: @service_token, signature: @signature }
    service_token - токен идентификации сервиса,
    signature - ключ, которым был подписан service_token
    
  </li>
  <li>
    Подтверждение микросервиса
    <br>
     Провайдер формирует POST запрос на @gate_host со следующим телом: {hashed_signature: md5(@signature), method: 'confirm'}
      @hashed_signature - md5 от @signature
      'confirm' - означает что это запрос подтверждения регистрации и в качестве ответа ожидается {signature: @signature} 
  </li>
  <li>
    Обновление микросервиса
    <br>
    Провайдер формирует POST запрос на @gate_host со следующим телом: 
    {
      method: 'update',
      permissions: {
        @service_name: {
          host: @host,
          token: @access_token
        },
      },
      allows: {
        @access_token: @ip
      }
    }
    @ip - IP адрес с которого был вызван запрос регистрации микросервиса
    @access_token - уникальный ключ для каждой пары microservice1 -> microservice2 
по которому 1 мироксервис отправляет запрос, а другой принимает.
  </li>
</ul>
