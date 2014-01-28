# -*- mode: ruby -*-
# vi: set ft=ruby :

DOCKER_URL = "192.168.50.4"
DOCKER_PORT = 5422

Vagrant.configure("2") do |config|
  config.vm.box = "boot2docker-0.4.0"
  config.vm.box_url = "https://github.com/mitchellh/boot2docker-vagrant-box/releases/download/v0.4.0/boot2docker.box"
  config.vm.network "forwarded_port", guest: DOCKER_PORT, host: DOCKER_PORT
  # config.vm.network :private_network, ip: DOCKER_URL
  # config.vm.provision :docker do |d|
  #   d.pull_images "ubuntu"
  # end
  config.vm.provision :shell, :inline => <<-PREPARE
  INITD=/usr/local/etc/init.d/docker
  sudo sed -i -e 's/docker -d .* $EXPOSE_ALL/docker -d -H 0.0.0.0:#{DOCKER_PORT}/' $INITD
  sudo $INITD restart
  PREPARE
end
