# tomcat6 Module #

This module provides mechanisms to manage tomcat6 instances

# Examples #

```puppet
 tomcat6::instance { 'webapp1':
   account       => 'app_webapp1',
   ajp_port      => '8081',
   http_port     => '8080',
   shutdown_port => '9000',
 }
```

## Cluster support ##

```puppet
        tomcat6::instance { 'webapp2':
            base_dir       => '/opt',
            account        => 'tomcat',
            ajp_port       => '8114',
            http_port      => '9114',
            shutdown_port  => '9504',
            catalina_opts  => "-server -Xms6144m -Xmx6144m -Djava.awt.headless=true -XX:PermSize=128m -XX:MaxNewSize=512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true",
            tomcat_cluster => {
                membership => {
                        address   => "224.0.0.5",
                        port      => "12345",
                        frequency => "500",
                        droptime  => "3000"
                },
                receiver   => {
                        address         => "auto",
                        port            => "54321",
                        selectortimeout => "100",
                        maxthreads      => "6",
                        autobind        => "100",
                },
                deployer   => {
                        tempdir      => "/tmp/tomcat-tmp/",
                        deploydir    => "webapps",
                        watchdir     => "/tmp/tomcat-watchdir/",
                        watchenabled => false
                }
            }
        }
```

## Resource ##

```puppet
	tomcat6::resource { "webapp2-CONN" :
            resource => '       <Resource name="jdbc/CONN" type="javax.sql.DataSource"
              url="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=<so.me.IP.add)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=<svcname>)))"
              username="<username>" password="<password>"
              maxActive="70" maxWait="15000" maxIdle="10"
              driverClassName="oracle.jdbc.driver.OracleDriver"
              validationQuery="SELECT 1 FROM DUAL"
              removeAbandonedTimeout="300" logAbandoned="false" testOnBorrow="true"/>
              ',
            target => "/opt/tomcat/tomcat6-webapp2/conf/server.xml"
        } 
```

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
