# CentOS Vagrant Provisioning Bash Scripts

This is a development VM, not suited for production (e.g. SELinux is disabled and more). It is a great virtual machine for web developing.


Based on <a href="https://github.com/fideloper/Vaprobash/">Vaprobash</a> and <a href="https://github.com/williamium/base-vagrant">williamium</a>, so if you are looking for Ubuntu alternative make sure to check those two.

## Details
<ul>
  <li>You can choose between different versions of PHP.</li>
  <li>You can choose between different versions of MariaDB.</li>
  <li>Latest version on nGinx.</li>
  <li>You can install NodeJS and global packages.</li>
  <li>It will search your shared folder and setup websites for each directory there, including the database if available.</li>
  <li>Lastly it will use wpcli to install WordPress and setup a database.</li>
</ul>
