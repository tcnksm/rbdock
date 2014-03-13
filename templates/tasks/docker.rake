require 'rbdock'

namespace :docker do

  desc "Create Dockerfile"
  task :create do
    options = {
      :image => 'ubuntu',
      :ruby_versions => ['2.0.0p353'],
      :use_rbenv => true
      # uncomment this line if you want to use rvm
      #, :use_rvm => true
    }

    Rbdock::Generate.run(options)
    puts "create Dockerfile OK."
  end

  desc "Build Docker image"
  task :build do
    tag = ENV['tag']
    fail "please use `bundle exec rake:docker build <TAG_NAME>` to build a Docker iamge" if tag.nil?
    build_cmd = "docker build -t #{tag} ."
    puts "building #{build_cmd}"
    system build_cmd
    puts "build Docker image OK."
  end

  desc "run a Docker container"
  task :run do
    puts "run container"
    params, tag, cmd = ENV['params'], ENV['tag'], ENV['cmd']
    run_cmd = "CONTAINER_ID=$(docker run #{params} #{tag} #{cmd}) && echo $CONTAINER_ID > tmp/docker.cid"
    puts "Docker CMD: #{run_cmd}"
    system run_cmd
    puts "CONTAINER_ID: #{`cat tmp/docker.cid`}"
  end

  desc "kill a Docker container"
  task :kill do
    cid_file = 'tmp/docker.cid'
    if File.exist? cid_file
      container_id = `cat tmp/docker.cid`
      fail "invalid container Id" unless /[0-9a-z]{64}/.match(container_id)
      kill_cmd = "docker kill #{container_id}"
      puts "KILL CMD: #{kill_cmd}"
      system kill_cmd
      puts "Killed"
      File.delete cid_file
    end
  end

  desc "show the container's state"
  task :state do
    container_json = JSON.parse(`cat tmp/docker.cid | xargs docker inspect`)
    running = if $?.exitstatus == 0; container_json[0]['State']['Running']; else false; end
    if running; puts "Running"; else puts "Stopped"; end
  end
end
