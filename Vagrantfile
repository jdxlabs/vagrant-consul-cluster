MASTER_COUNT = 1
NODE_COUNT = 1
IMAGE = "ubuntu/bionic64"

Vagrant.configure("2") do |config|

  (1..MASTER_COUNT).each do |i|
    config.vm.define "consulmaster#{i}" do |consulmasters|
      consulmasters.vm.box = IMAGE
      consulmasters.vm.hostname = "consulmaster#{i}"
      consulmasters.vm.network  :private_network, ip: "10.0.0.#{i+10}"
      consulmasters.vm.provision "file", source: "./.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
      consulmasters.vm.provision "shell", privileged: true,  path: "scripts/master_install.sh"
    end
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "consulnode#{i}" do |consulnodes|
      consulnodes.vm.box = IMAGE
      consulnodes.vm.hostname = "consulnode#{i}"
      consulnodes.vm.network  :private_network, ip: "10.0.0.#{i+20}"
      consulnodes.vm.provision "file", source: "./.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
      consulnodes.vm.provision "shell", privileged: true,  path: "scripts/node_install.sh"
    end
  end
end