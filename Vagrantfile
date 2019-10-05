Vagrant.configure('2') do |config|
  config.vm.box = 'genebean/centos-7-docker-ce'
  config.vm.provision 'shell', inline: <<-SCRIPT
    git clone https://github.com/jpogran/dependabot-core.git /opt/dependabot-core
    cd /opt/dependabot-core
    git checkout puppet-langauge-support
    docker build -t dependabot/dependabot-core .
    cat /vagrant/deps/Dockerfile.ci > /opt/dependabot-core/Dockerfile.ci
    docker build -f Dockerfile.ci -t genebean/dependabot-ci .
    cd /vagrant
    docker build -t genebean/dependabot-control-repo-demo .
  SCRIPT
end
