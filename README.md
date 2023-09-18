# gem для работы с HalykBank ePay

Gem для работы с платежным шлюзом HalykBank ePay 2.0 для использования в проектах, использующих Ruby (Ruby On Rails, Sinatra и др.).

## Установка

Добавьте эту строку в ваш Gemfile:

    gem 'halyk_epay'

Затем установите gem, используя bundler:

    $ bundle

Или выполните команду:

    $ gem install halyk_epay

## Использование (примеры с использованием Ruby On Rails)

### Настройка

Для использования гема его нужно предварительно настроить. Например, можно создать файл
`config/initializers/halyk_epay.rb` с подобным содержимым:

```ruby
HalykEpay.configure do |c|
  c.client_id = 'Some Client'
  c.client_secret = 'yF587AV9Ms94qN2QShFzVR3vFnWkhjbAK3sG'
  c.terminal_id = '67e34d63-102f-4bd1-898e-370781d0074d'
  c.test_mode? = false
end
```

эти данные вам будут выданы при регистрации.


### Получить токен

```ruby
token_params = {
    invoiceID: 		"000000001",
    amount: 		100,
    ...,
}

data = HalykEpay::Token.new(token_params)

# объект токена, все данные полученные от epay по запросу токена
data.token

# токен - "f2288c2b-1d08-4aac-a210-d62c0901f915"
data.access_token
```

Базовые параметры (grant_type, scope, client_id, client_secret) добавлять не нужно.


### Платежи

#### Получение данных о платеже (статуса оплаты)

```ruby
transaction = HalykEpay::Transaction.new(token, id).receive

# код ответа при получении транзакции
transaction.code

# сообщение в ответе при получении транзакции
transaction.message

# данные и транзакции
transaction.transaction_data

# операция в процессе выполнения
transaction.in_progress?

# операция успешна
transaction.success?

# операция провалена
transaction.failed?

# списана ли оплата
transaction.amount_charged?

```

#### Подтверждение оплаты

```ruby
payment = HalykEpay::Payment.new(token, id)

# подтверждение оплаты
payment.charge

# отмена оплаты
payment.cancel
```

при получении данных о платеже, id, это номер заказа

при подтверждении/отмены платежа, id, это id транзакции который вы получили ранее в postlink после удачной оплаты или при запросе статуса оплаты
