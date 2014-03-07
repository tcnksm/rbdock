# rbdock

[![Gem Version](https://badge.fury.io/rb/rbdock.png)](http://badge.fury.io/rb/rbdock)

Generate Dockerfile for Ruby or Rails, Sinatra.

Dockerfile to prepare ruby is almost common, so generate its common parts. This is still experimetal and under heavy construction.

## Installation

Add this line to your application's Gemfile:

    gem 'rbdock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbdock


## Usage

### Create Dockerfile to build ruby

Create `Dockerfile` to build ruby 2.1.0 ready image.

```
$ rbdock 2.1.0
```

It generates this [Dockerfile](https://gist.github.com/tcnksm/9388685). 

You can create `Dockerfile` to build multiple versions of ruby by rbenv or rvm.

```
$ rbdock 2.0.0-p353 1.9.3-p484 -i centos
```

It generates this [Dockerfile](https://gist.github.com/tcnksm/9388736). 


### Create Dockerfile for rails/sinatra application

For example, you can work with rails application developed on local environment. 

```
$ rails new my_rails_app
$ rbdock 2.1.0 --app my_rails_app --rbenv
$ docker build -t tcnksm/rails_app .
$ docker run -i -p 3000:3000 -t tcnksm/rails_app 'rails server'
```

It generates this [Dockerfile](https://gist.github.com/tcnksm/9389036). 

You can work with application hosted on remote repository. For example, this is my sinatra application hosted on github. 

```
$ rbdock 2.0.0-p353 --app https://github.com/tcnksm/trying-space
$ docker build -t tcnksm/sinatra_app .
$ docker run -i -p 8080:8080 -t tcnksm/my_sinatra_app 'rackup -p 8080'
```
It generates this [Dockerfile](https://gist.github.com/tcnksm/9389116). Your application will be cloned to local directory (`.rbdock_app`) and `ADD` to docker image.

### Options

|Option | Description |
|:----- |:----------- |
|--image `name`| Set base image. Now `ubuntu` or `cenos` is avalable. Default is `ubuntu`.|
|--rbenv| Use [rbenv](https://github.com/sstephenson/rbenv) to manage ruby installation|
|--rvm  | Use [rvm](https://github.com/wayneeseguin/rvm) to manage ruby installation|
|--app `url` | Add Rails/Sinatra application. You can set local path or remote host|
|--list | List all available ruby versions.|


## Contributing

1. Fork it ( http://github.com/<my-github-username>/rbdock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
