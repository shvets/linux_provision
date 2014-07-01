$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

class Docker < Thor
  desc "execute", "execute"
  def execute *params
    ENV['DOCKER_HOST'] = "tcp://192.168.59.103:2375"

    exec *params
  end

  desc "all", "all"
  def all
    # Build containers from Dockerfiles
    execute <<-CODE
    # Reset
    docker stop demo
    docker rm demo

    # Build containers
    # docker build -t postgres docker/postgres
    docker build -t demo demo
    docker run -d -p 42222:22 -p 9292:9292 --name demo demo

    # Run and link the containers
    # docker run -d -p 5432:5432 --name postgres postgres:latest

    # docker run --rm --name demo demo:latest /bin/bash -l -c "rake db:migrate"
    # docker run --rm -p 22 -p 9292:9292 --name demo demo:latest /bin/bash -l -c "rackup"
    # docker run -d -p 9292:9292 --name demo demo:latest /bin/bash -l -c "rackup"
    CODE
  end
end
