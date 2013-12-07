Vagrant Development Environment
=============

This project simplifies the process of web development by creating a simple server environment with apache2, mysql-server, and php.

This projects assumes you have already installed the following:
* git (http://git-scm.com/downloads) (ex: v1.8.4.3)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads) (ex: v4.3.2)
* vagrant (http://downloads.vagrantup.com/) (ex: v1.3.5)

Note: On Windows when installing Git it is recommended that you select the option to include the bin directory in your path to use the vagrant ssh command.  Otherwise you can use a differt ssh client such as PuTTY.

Now add a few plugins to your vagrant environment from the commandline:
* `vagrant plugin install vagrant-vbguest` Ensures that the "guest additions" on the guest os is up to date. 
* `vagrant plugin install vagrant-omnibus` Installs ruby and chef on the guest os allowing the vagrant script to complete.


Stackalicious Vagrant environment contains a 'sites' directory where you can provide your own website files to be hosted in the virtual environment.  As an example the following instructions will install a simple website called campapp.

> cd vagrant-lamp/sites  
> git clone git@github.com:dnielsen/campapp.git  
> cd ..  
> vagrant up  

Once complete you will have a complete webserver hosting your sample website.  

Q: How do I see the webpage  
A: Open your web browser and type '192.168.56.3' for the url.  This is the static ip assigned to the vm from Vagrantfile.  

Q: Can I directly access the virtual machine?  
A: Graphical access is not enabled. To access from the command line type `vagrant ssh` from the vagrant-lamp directory. For Windows you may need to use PuTTY if ssh is not accessible from the command line, see note above.

Q: How is the server configured?  
A: The Vagrantfile script defines memory and operating system parameters.  The `setup_env.sh` is used to install and configure primary applications: apache, php and mysql.  Finally sites are expected to have a `setup_app.sh` which configures the apache virtual host and populates the database in the  campapp example.

Q: How can I make changes to the site?  
A: You can change the website directly from the sites folder and refresh the browser to see the results.

Q: How do I shutdown/restart/startover the virtual machine in case things go wrong?  
A: `vagrant halt` / `vagrant reload` / `vagrant destroy`  Also if you want to rerun the script use `vagrant provison`.

