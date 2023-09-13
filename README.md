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
end
```

Все эти данные вам будут выданы при регистрации.


### Получить токен

```ruby
token_params = {
    invoiceID: 		"000000001",
    amount: 		100,
    ...,
}

token = HalykEpay::Token.new(token_params).receive

```

* Базовые параметры (grant_type, scope, client_id, client_secret) добавлять не нужно.


### Платежи

```ruby
HalykEpay::Payment.new(token, id)
```

* при получении данных о платеже id - это номер заказа
** в остальных случаях id - это id транзакции который вы получили ранее в postlink после удачной оплаты или при запросе статуса оплаты


#### Получение данных о платеже (статуса оплаты)

```ruby
payment.receive

# код ответа при получении транзакции
payment.code

# сообщение в ответе при получении транзакции
payment.message

# данные и транзакции
payment.transaction_data

# операция в процессе выполнения
payment.in_progress?

# операция успешна
payment.success?

# операция провалена
payment.failed?

# списана ли оплата
payment.amount_charged?

```

#### Подтверждение оплаты*

```ruby
payment.charge
```

#### Отмена оплаты*

```ruby
payment.cancel
```

* для подтверждения/отмены платежа необходимо чтобы оплата находилась в статусе Auth.
