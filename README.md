
About
=====

This Vagrant project stands up an autonomous CI/CD pipeline consisting of:

* Jenkins
* Nexus
* ...

Setup
=====

This guide assumes that you have Vagrant installed (https://www.vagrantup.com/downloads.html).

This guide assumes that you have vbguest plugin installed. If you do not, you can install it with:

```
vagrant plugin install vagrant-vbguest
```

Clone the repo and do:

```
vagrant up
```

or if you are doing it iteratively with a single copy of the project:

```
vagrant destroy -f && vagrant up
```

Incremental changes are deployed to the VM via:
```
vagrant provision
```

Usage
=====

Jenkins becomes available at `http://localhost:8082`.

Nexus becomes available at `http://localhost:8085/nexus`.





