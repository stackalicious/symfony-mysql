Vagrant Development Environment
=============

This project simplifies the process of web development by creating a simple server environment with apache2, mysql-server, and php.

This projects assumes you have already installed the following:
* git (http://git-scm.com/downloads)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)
* vagrant (http://downloads.vagrantup.com/)

Now add a few plugins to your vagrant environment from the commandline:
* vagrant plugin install vagrant-vbguest
* vagrant plugin install vagrant-omnibus

The first one ensures that the guest additions package has the same version as the guest additions package on the host os.
The second plugin installs ruby and chef on the guest os allowing the vagrant script to complete.

Next navigate into the vagrant-lamp directory and execute the 'vagrant up' command.  Once complete you will have a working virtual machine.  To access type 'vagrant ssh'.  This is a working Ubuntu 12.04 instance.

If you are still inside the virtual machine instance type 'exit' to return to the host os.  Next let's setup a website to host on the virtual machine.  Run 'git clone https://github.com/dnielsen/campapp.git sites/campapp'.  

Now we have a simple php website installed into the directory sites/campapp.  Next run 'vagrant provision' to configure the site.  Once this completes point your browser to 192.168.56.3.

If everything worked correctly you should now see the sample website.

