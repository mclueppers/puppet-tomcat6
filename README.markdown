# tomcat6 Module #

This module provides mechanisms to manage tomcat6 instances

# Examples #

<pre><code>
 tomcat6::instance { 'webapp1':
   account       => 'app_webapp1',
   ajp_port      => '8081',
   http_port     => '8080',
   shutdown_port => '9000',
 }
</code></pre>
 

License
-------

Affero GPL

Contact
-------

Martin Dobrev <git@dobrev.eu>

Initial version by
------------------

Aaron Russo <arusso@berkeley.edu>

Support
-------

Please log tickets and issues at the
[Projects site](https://github.com/mclueppers/puppet-tomcat6/issues/)
