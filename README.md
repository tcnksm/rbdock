# rbdock

[![Gem Version](https://badge.fury.io/rb/rbdock.png)](http://badge.fury.io/rb/rbdock)

Dockerfile to prepare ruby is almost common, so generate it. This is still experimetal and under construction.

## Installation

Add this line to your application's Gemfile:

    gem 'rbdock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbdock


## Usage

Create `Dockerfile` to build ruby 2.0.0-p353 ready image.

```
$ rbdock create 2.0.0-p353
```

You can create `Dockerfile` to build multiple versions of ruby.

```
$ rbdock create 2.0.0-p353 1.9.3-p484
```

### Options

|Option | Description |
|:----- |:----------- |
|--image `name`| Set base image. Now `ubuntu` or `cenos` is avalable. Default is `ubuntu`.|
|--rbenv| Use [rbenv](https://github.com/sstephenson/rbenv) to manage ruby installation|
|--rvm  | Use [rvm](https://github.com/wayneeseguin/rvm) to manage ruby installation|
|--list | List all available ruby versions.|


## Contributing

1. Fork it ( http://github.com/<my-github-username>/rbdock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
