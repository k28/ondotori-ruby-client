## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ondotori-ruby-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ondotori-ruby-client

## Usage

### Create API Key

The first step is to create an API key.

- [おんどとり Web Storage](https://ondotori.webstorage.jp/account/create-apikey.php)
- [T&D WebStorage Service](https://www.webstorage-service.com/account/create-apikey.php)

### Web Client

#### Web Client Examples

```
params = { "api-key" => "API Key you create", "login-id" => "tbxxxx", "login-pass" => "password"}
client = Ondotori::WebAPI::Client.new(params)
```

| key        | value                             |
|------------|-----------------------------------|
| api-key    | API Key                           |
| login-id   | Read-only IDs are also available. |
| login-pass | password                          |


#### Get Current Readings

To get current readings, do the following.

```
response = client.current()
```
#### Get Latest Data

To get latest data, do the following.

```
response = client.latest_data("SERIAL")
```

#### Get Latest Data RTR500

To get latest data (RTR500), do the following.

```
response = client.latest_data_rtr500(base: "BaseUnit Serial", remote: "RemoteUnit Serial")
```

#### Get Data (TR-7wb/nw/wf, TR4)

To get data (TR-7wb/nw/wf, TR4), do the following.

```
from = Time.now - (3600 * 24)
to   = Time.now
limit = 16000
data_range = Ondotori::WebAPI::Api::DataRange.new(from: from, to: to, limit: 10)
response = client.data("Device Serial", data_range: data_range)
```
data_range parameter is optional.

#### Get Data (RTR500 Series)

To get data (RTR500 Series), do the following.

```
from = Time.now - (3600 * 24)
to   = Time.now
limit = 16000
data_range = Ondotori::WebAPI::Api::DataRange.new(from: from, to: to, limit: 10)
response = client.data_rtr500(base: "BaseUnit Serial", remote: "Device Serial", data_range: data_range)
```
data_range parameter is optional.

#### Error Handling

Ondotori Errors

In case of parameter abnormality or error returned from the web server, the error will be raised.
For example, to receive an authentication error from the server, use the following.
```
rescue Ondotori::WebAPI::Api::Errors::ResponseError => e
  # puts "Response error #{e.messaeg}"
end
```
All of these errors inherit from `Ondotori::WebAPI::Api::Errors::Error`, so you can handle or silence all errors if necessary:
```
rescue Ondotori::WebAPI::Api::Errors::Error => e
  # puts "Response error #{e.messaeg}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/k28/ondotori-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ondotori-ruby-client/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ondotori::Ruby::Client project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ondotori-ruby-client/blob/master/CODE_OF_CONDUCT.md).
