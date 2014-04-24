VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #Ubuntu 12.04
  config.vm.define "ubuntu12" do |ubuntu12_config|
    ubuntu12_config.vm.box = "ubuntu-12-x64"
    ubuntu12_config.vm.box_url = "/Users/jolly_rojer/Projects/Cometera/vagrant-boxes/ubuntu-12-x64.box"
    ubuntu12_config.vm.hostname = "ubuntu12.qubell.int"
    ubuntu12_config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    ubuntu12_config.vm.network "forwarded_port", guest: 8090, host: 8090, auto_correct: true
    ubuntu12_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    ubuntu12_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    ubuntu12_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/tomcat/cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/zookeeper/cookbooks"]
      #chef.add_recipe "tomcat-component"
      #chef.add_recipe "zookeeper-component"
      #chef.add_recipe "solr"
      #chef.add_recipe "solr::create_collection"
      chef.add_recipe "solr::delete_collection"
      #chef.add_recipe "tomcat-component::manage"
      chef.add_recipe "solr::create_collection"
      chef.add_recipe "tomcat-component::manage"
      #chef.add_recipe "tomcat-component::deploy_libs"
      #chef.add_recipe "tomcat-component::deploy_war"
        chef.json = {
          "tomcat" => {
            "java_options" => "${JAVA_OPTS} -DnumShards=1",
            "manage" => {
              "services" => ["tomcat6"],
              "action" => "restart"
            },
          },
          "tomcat-component" => {
            "lib_uri" => ["file:///tmp/solr-4.6.0/example/lib/ext/jcl-over-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/jul-to-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/log4j-1.2.16.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-api-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-log4j12-1.6.6.jar"],
            "war_uri" => "file:///opt/solr/webapps/solr.war",
            "context" => {
              "context_attrs" => {
                "docBase" => "file:///opt/solr/webapps/solr.war",
                "debug" => "5",
                "crossContext" => "true",
                "privileged" => "true",
                "allowLinking" => "true"
              },
              "context_nodes" => [
                {
                  "Environment" => {
                    "name" => "solr/home",
                    "type" => "java.lang.String",
                    "value" => "/opt/solr/cores",
                    "override" => "true"
                  }
                }
              ]
            } 
          },
          "solr" => {
            "collection" => ["haha"],
            "zookeeper" => {
                "hosts" => ["127.0.0.1"]
            },
            "port" => "8080",
            "loglevel" => "FINEST"
          },
          "exhibitor" => {
            "opts" => {
              "port" => "8090"
            }
          }
        }
    end
  end
  
  #Ubuntu 10.04
  config.vm.define "ubuntu10" do |ubuntu10_config|
    ubuntu10_config.vm.box = "ubuntu-10-x64"
    ubuntu10_config.vm.box_url = "/Users/jolly_rojer/Projects/Cometera/vagrant-boxes/ubuntu-10-x64.box"
    ubuntu10_config.vm.hostname = "ubuntu10.qubell.int"
    ubuntu10_config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    ubuntu10_config.vm.network "forwarded_port", guest: 8090, host: 8090, auto_correct: true
    ubuntu10_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    ubuntu10_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    ubuntu10_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/tomcat/cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/zookeeper/cookbooks"]
      chef.add_recipe "tomcat-component"
      chef.add_recipe "zookeeper-component"
      chef.add_recipe "solr"
      chef.add_recipe "solr::create_collection"
      #chef.add_recipe "solr::delete_collection"
      chef.add_recipe "tomcat-component::manage"
      #chef.add_recipe "solr::create_collection"
      #chef.add_recipe "tomcat-component::manage"
      chef.add_recipe "tomcat-component::deploy_libs"
      chef.add_recipe "tomcat-component::deploy_war"
        chef.json = {
          "tomcat" => {
            "java_options" => "${JAVA_OPTS} -DnumShards=1",
            "manage" => {
              "services" => ["tomcat6"],
              "action" => "restart"
            },
          },
          "tomcat-component" => {
            "lib_uri" => ["file:///tmp/solr-4.6.0/example/lib/ext/jcl-over-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/jul-to-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/log4j-1.2.16.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-api-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-log4j12-1.6.6.jar"],
            "war_uri" => "file:///opt/solr/webapps/solr.war",
            "context" => {
              "context_attrs" => {
                "docBase" => "file:///opt/solr/webapps/solr.war",
                "debug" => "5",
                "crossContext" => "true",
                "privileged" => "true",
                "allowLinking" => "true"
              },
              "context_nodes" => [
                {
                  "Environment" => {
                    "name" => "solr/home",
                    "type" => "java.lang.String",
                    "value" => "/opt/solr/cores",
                    "override" => "true"
                  }
                }
              ]
            } 
          },
          "solr" => {
            "collection" => ["testme2"],
            "zookeeper" => {
                "hosts" => ["127.0.0.1"]
            },
            "port" => "8080",
            "loglevel" => "FINEST"
          },
          "exhibitor" => {
            "opts" => {
              "port" => "8090"
            }
          }
        }
    end
  end
  
  #CentOS 5.6
  config.vm.define "centos56" do |centos56_config|
    centos56_config.vm.box = "centos-5-x64"
    centos56_config.vm.box_url = "/Users/jolly_rojer/Projects/Cometera/vagrant-boxes/centos-5-x64.box"
    centos56_config.vm.hostname = "centos56.qubell.int"
    centos56_config.vm.network "forwarded_port", guest: 8080, host: 9000, auto_correct: true
    centos56_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    centos56_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    centos56_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/tomcat/cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/zookeeper/cookbooks"]
      chef.add_recipe "tomcat-component"
      chef.add_recipe "zookeeper-component"
      chef.add_recipe "solr"
      chef.add_recipe "solr::create_collection"
      #chef.add_recipe "solr::delete_collection"
      chef.add_recipe "tomcat-component::manage"
      #chef.add_recipe "solr::create_collection"
      #chef.add_recipe "tomcat-component::manage"
      chef.add_recipe "tomcat-component::deploy_libs"
      chef.add_recipe "tomcat-component::deploy_war"
        chef.json = {
          "tomcat" => {
            "java_options" => "${JAVA_OPTS} -DnumShards=1",
            "manage" => {
              "services" => ["tomcat6"],
              "action" => "restart"
            },
          },
          "tomcat-component" => {
            "lib_uri" => ["file:///tmp/solr-4.6.0/example/lib/ext/jcl-over-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/jul-to-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/log4j-1.2.16.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-api-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-log4j12-1.6.6.jar"],
            "war_uri" => "file:///opt/solr/webapps/solr.war",
            "context" => {
              "context_attrs" => {
                "docBase" => "file:///opt/solr/webapps/solr.war",
                "debug" => "5",
                "crossContext" => "true",
                "privileged" => "true",
                "allowLinking" => "true"
              },
              "context_nodes" => [
                {
                  "Environment" => {
                    "name" => "solr/home",
                    "type" => "java.lang.String",
                    "value" => "/opt/solr/cores",
                    "override" => "true"
                  }
                }
              ]
            } 
          },
          "solr" => {
            "collection" => ["testme2"],
            "zookeeper" => {
                "hosts" => ["127.0.0.1"]
            },
            "port" => "8080",
            "loglevel" => "FINEST"
          },
          "exhibitor" => {
            "opts" => {
              "port" => "8090"
            }
          }
        }
    end
  end

  #CentOS 6.3
  config.vm.define "centos63" do |centos63_config|
    centos63_config.vm.box = "centos_6_x64"
    centos63_config.vm.box_url = "/Users/jolly_rojer/Projects/Cometera/vagrant-boxes/centos_6_x64.box"
    centos63_config.vm.hostname = "centos63.qubell.int"
    centos63_config.vm.network "forwarded_port", guest: 8080, host: 9010, auto_correct: true
    centos63_config.vm.network "public_network", :bridge => 'en0: Wi-Fi (AirPort)'
    centos63_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    centos63_config.vm.provision "chef_solo" do |chef| 
      chef.log_level = "debug"
      chef.cookbooks_path = ["cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/tomcat/cookbooks", "/Users/jolly_rojer/Projects/Cometera/components/zookeeper/cookbooks"]
      #chef.add_recipe "tomcat-component"
      #chef.add_recipe "zookeeper-component"
      #chef.add_recipe "solr"
      #chef.add_recipe "solr::create_collection"
      chef.add_recipe "solr::delete_collection"
      #chef.add_recipe "tomcat-component::manage"
      chef.add_recipe "solr::create_collection"
      chef.add_recipe "tomcat-component::manage"
      #chef.add_recipe "tomcat-component::deploy_libs"
      #chef.add_recipe "tomcat-component::deploy_war"
        chef.json = {
          "base" => {
            "manage" => {
              "services" => ["tomcat6"],
              "action" => "restart"
            }
          },
          "tomcat" => {
            "java_options" => "${JAVA_OPTS} -DnumShards=1",
          },
          "tomcat-component" => {
            "lib_uri" => ["file:///tmp/solr-4.6.0/example/lib/ext/jcl-over-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/jul-to-slf4j-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/log4j-1.2.16.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-api-1.6.6.jar", "file:///tmp/solr-4.6.0/example/lib/ext/slf4j-log4j12-1.6.6.jar"],
            "war_uri" => "file:///opt/solr/webapps/solr.war",
            "context" => {
              "context_attrs" => {
                "docBase" => "file:///opt/solr/webapps/solr.war",
                "debug" => "5",
                "crossContext" => "true",
                "privileged" => "true",
                "allowLinking" => "true"
              },
              "context_nodes" => [
                {
                  "Environment" => {
                    "name" => "solr/home",
                    "type" => "java.lang.String",
                    "value" => "/opt/solr/cores",
                    "override" => "true"
                  }
                }
              ]
            } 
          },
          "solr" => {
            "collection" => ["hello"],
            "zookeeper" => {
                "hosts" => ["127.0.0.1"]
            },
            "port" => "8080",
            "loglevel" => "FINEST"
          },
          "exhibitor" => {
            "opts" => {
              "port" => "8090"
            }
          }
        }
    end
  end
end
