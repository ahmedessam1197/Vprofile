Vagrant.configure("2") do |config|
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  
    ## DB VM 
    config.vm.define "db01" do |db01|
      db01.vm.box = "eurolinux-vagrant/centos-stream-9"
      db01.vm.hostname = "db01"
      db01.vm.network "private_network", ip: "192.168.10.15"
      db01.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
    # Provisioning mariadb.sh script
    db01.vm.provision "shell", path: "mariadb.sh", privileged: true
    end

    # Memcache VM
    config.vm.define "mc01" do |mc01|
      mc01.vm.box = "eurolinux-vagrant/centos-stream-9"
      mc01.vm.hostname = "mc01"
      mc01.vm.network "private_network", ip: "192.168.10.14"
      mc01.vm.provider "virtualbox" do |vb|
        vb.memory = "900"
      end
    # Provisioning  memcached.sh script
    mc01.vm.provision "shell", path: "memcached.sh", privileged: true
    end

    # RabbitMQ VM
    config.vm.define "rmq01" do |rmq01|
      rmq01.vm.box = "eurolinux-vagrant/centos-stream-9"
      rmq01.vm.hostname = "rmq01"
      rmq01.vm.network "private_network", ip: "192.168.10.13"
      rmq01.vm.provider "virtualbox" do |vb|
        vb.memory = "600"
      end
    # Provisioning rabbitmq.sh script
    rmq01.vm.provision "shell", path: "rabbitmq.sh", privileged: true
    end

    # Tomcat VM
    config.vm.define "app01" do |app01|
      app01.vm.box = "eurolinux-vagrant/centos-stream-9"
      app01.vm.hostname = "app01"
      app01.vm.network "private_network", ip: "192.168.10.12"
      app01.vm.provider "virtualbox" do |vb|
        vb.memory = "4200"
      end
    # Provisioning tomcat.sh script
    app01.vm.provision "shell", path: "tomcat.sh", privileged: true
    end

    # Nginx VM
    config.vm.define "web01" do |web01|
        web01.vm.box = "ubuntu/jammy64"
        web01.vm.hostname = "web01"
        web01.vm.network "private_network", ip: "192.168.10.11"
        web01.vm.provider "virtualbox" do |vb|
          vb.memory = "800"
        end
    # Provisioning nginx.sh script
    web01.vm.provision "shell", path: "nginx.sh", privileged: true
    end
end