PXC training PXE server
========================

This module builds a Kickstart CentOS server that can be used to PXE build classroom machines en-masse.


Usage
------

Build the server with 'vagrant up' and test.  Test VM can be used as long as it talks on the same secondary network as the PXE server and does a network boot on the first startup.

Exporting VM
---------------

Once the PXE server is built and tested, it needs to be prepared for usage in the training facility.  At this point, Vagrant ceases to manage the box, and you interact with it directly in VMware.

* Remove the primary network adapter
* Make the secondary be a bridged network
* rm -f /etc/udev/rules.d/70-persistent-net.rules
* Be sure /etc/sysconfig/network-scripts/ifcfg-eth0 contains the rules from eth1 and eth1's config is gone.  

The goal is that when the VM next starts it comes up with its own static IP (10.10.10.5) on eth0.