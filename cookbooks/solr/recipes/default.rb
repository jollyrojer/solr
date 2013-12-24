#
# Cookbook Name:: solr-component
# Recipe:: default
#

require "pathname"
include_recipe "tomcat"

# Since solr 4.3.0 we need slf4j jar http://wiki.apache.org/solr/SolrLogging#Solr_4.3_and_above
# # TODO use an external cookbook
["slf4j-jdk14-#{node["solr"]["slf4j"]["version"]}.jar", "log4j-over-slf4j-#{node["solr"]["slf4j"]["version"]}.jar", "slf4j-api-#{node["solr"]["slf4j"]["version"]}.jar", "jcl-over-slf4j-#{node["solr"]["slf4j"]["version"]}.jar"].each do |file|
  ark file do
    url "#{node["solr"]["slf4j"]["url"]}/slf4j-#{node["solr"]["slf4j"]["version"]}.tar.gz"
      action :cherry_pick
      creates ::File.join("slf4j-#{node["solr"]["slf4j"]["version"]}", file)
      path ::File.join(node["tomcat"]["home"],"lib")
    end
end

# Extract war file from solr archive
solr_url = "#{node["solr"]["url"]}#{node["solr"]["version"]}/solr-#{node["solr"]["version"]}.tgz"
remote_file "solr_src" do
  path "/tmp/solr-#{node["solr"]["version"]}.tgz"
  source solr_url
  action :create_if_missing
end

execute "extract solr_src" do
  command "tar -xzvf /tmp/solr-#{node["solr"]["version"]}.tgz -C /tmp/"
  creates "/tmp/solr-#{node["solr"]["version"]}"
end

#Copy sorl.war to webapps
directory "#{node["solr"]["path"]}/webapps" do
  mode 00755
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  recursive true
  action :create
end

execute "copy sorl.war" do
  command "cp /tmp/solr-#{node["solr"]["version"]}/dist/solr-#{node["solr"]["version"]}.war #{node["solr"]["path"]}/webapps/solr.war"
  creates "#{node["solr"]["path"]}/webapps/solr.war"
end

#Deploy solr to tomcat
template "#{node["solr"]["path"]}/webapps/solr.xml" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr-app.xml.erb"
end

execute "link solr app" do
  command "ln -s #{node["solr"]["path"]}/webapps/solr.xml #{node["tomcat"]["context_dir"]}/solr.xml"
  creates "#{node["tomcat"]["context_dir"]}/solr.xml"
end

#Create collections
node["solr"]["collection"].each do |collection|
  directory "#{node["solr"]["path"]}/cores/#{collection}/conf/" do
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    mode 00755
    recursive true
    action :create
  end

  template "#{node["solr"]["path"]}/cores/#{collection}/conf/schema.xml" do
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    source "schema.xml.erb"
    variables({
      :collection => "#{collection}"
    })
  end

  template "#{node["solr"]["path"]}/cores/#{collection}/conf/solrconfig.xml" do
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    source "solrconfig.xml.erb"
    variables({
      :collection => "#{collection}"
    })
  end
end

template "#{node["solr"]["path"]}/cores/solr.xml" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr.xml.erb"
  variables({
    :zooip => node["solr"]["zookeeper"]["host"],
    :zooport => node["solr"]["zookeeper"]["port"]
  })
end

execute "ln home" do
  command "ln -s #{node["solr"]["path"]} #{node["tomcat"]["base"]}/solr"
  creates "#{node["tomcat"]["base_dir"]}/solr"
end

#create zkcli
template "#{node["solr"]["path"]}/webapps/zkcli.sh" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 00755
  source "zkcli.sh.erb"
end

#populate zookeeper
zoo_connect = "#{node["solr"]["zookeeper"]["host"]}:#{node["solr"]["zookeeper"]["port"]}"
solr_cores = "#{node["solr"]["path"]}/cores"
node["solr"]["collection"].each do |collection|
  execute "upload zoo collection #{collection}" do
    command "#{node["solr"]["path"]}/webapps/zkcli.sh -cmd upconfig -zkhost #{zoo_connect} -d #{solr_cores}/#{collection}/conf/ -n #{collection}"
  end

  execute "link zoo collection #{collection}" do
    command "#{node["solr"]["path"]}/webapps/zkcli.sh -cmd linkconfig -zkhost #{zoo_connect} -collection #{collection} -confname #{collection} -solrhome #{solr_cores}"
  end

  execute "bootstrap zoo collection #{collection}" do
    command "#{node["solr"]["path"]}/webapps/zkcli.sh -cmd bootstrap -zkhost #{zoo_connect} -solrhome #{solr_cores}"
  end
end

execute "change solr owner" do
  command "chown -R #{node["tomcat"]["user"]}:#{node["tomcat"]["group"]} #{node["solr"]["path"]}"
end

if platform_family?('rhel')
  execute "stop iptables" do
    command "/etc/init.d/iptables stop"
  end
end

execute "restart tomcat" do
  command "/etc/init.d/tomcat6 stop && /etc/init.d/tomcat6 start"
end
