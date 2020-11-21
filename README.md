# Consul cluster deployed with Vagrant

These scripts allow the deployment of a Consul cluster running in Vagrant.

## Requirements
* Vagrant 2+
* Command line stuff

## Basics
Here are the basic commands,  

to launch and destroy the cluster quickly  
```
vagrant up --no-tty
vagrant destroy -f

# Or if you want to play
vagrant reload
```

to access the web ui of Consul  
```
vagrant ssh consulmaster1 -- -L 8500:localhost:8500

# and simply access to your ui : http://localhost:8500
```

## More informations
You can visit the associated blog post here : https://xxx.
