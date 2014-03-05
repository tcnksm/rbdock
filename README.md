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

Create `Dockerfile` to build ruby 2.0.0-p353 ready image.

```
$ rbdock 2.1.0
```

This generates 

```
FROM ubuntu

# Install basic packages
RUN apt-get update
RUN apt-get install -y build-essential wget curl git
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git .ruby-build
RUN .ruby-build/install.sh
RUN rm -fr .ruby-build

# Install ruby-2.1.0
RUN ruby-build 2.1.0 /usr/local

# Install bundler
RUN gem update --system
RUN gem install bundler --no-rdoc --no-ri
```

You can create `Dockerfile` to build multiple versions of ruby.

```
$ rbdock 2.0.0-p353 1.9.3-p484
```

This generates,

```
FROM ubuntu

# Install basic packages
RUN apt-get update
RUN apt-get install -y build-essential wget curl git
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN ./root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.0.0-p353
RUN rbenv install 1.9.3-p484

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'rbenv global 2.0.0-p353; gem update; gem install bundler'
RUN bash -l -c 'rbenv global 1.9.3-p484; gem update; gem install bundler'
```

You can work with rails or sinatra application.

```
$ rails new myapp
$ rbdock 2.1.0 --app myapp --rbenv
$ docker build -t tcnksm/my_rails_app .
$ docker run -i -p 3000:3000 -t tcnksm/my_rails_app bash -l -c 'rails server'
```

You can work with application host on remote repository

```
$ rbdock 2.1.0 --app https://github.com/tcnksm/trying-space
$ docker build -t tcnksm/my_sinatra_app .
$ docker run -i -p 8080:8080 -t tcnksm/my_sinatra_app bash -l -c 'rackup -p 8080'
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
