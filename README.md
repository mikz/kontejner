# Kontejner

Like [skydock](https://github.com/crosbymichael/skydock) + [skydns](https://github.com/skynetservices/skydns1), but in Ruby.

## Installation

Install it yourself as:

    $ gem install kontejner

Then run it like:
```bash
kontejner start --domain=docker --port=7079 --docker=$DOCKER_HOST
```

## Usage

* Use EventMachine http client rather than blocking excon in Docker Api

## Contributing

1. Fork it ( https://github.com/mikz/kontejner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
