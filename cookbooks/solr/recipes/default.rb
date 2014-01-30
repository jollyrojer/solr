#
# Cookbook Name:: solr-component
# Recipe:: default
#

require "pathname"

# Since solr 4.3.0 we need slf4j jar http://wiki.apache.org/solr/SolrLogging#Solr_4.3_and_above
slf4j_url = "#{node["solr"]["slf4j"]["url"]}/slf4j-#{node["solr"]["slf4j"]["version"]}.tar.gz"
remote_file "/tmp/slf4j-#{node["solr"]["slf4j"]["version"]}.tar.gz" do
  source slf4j_url
  action :create_if_missing
end

# Extract required libs
libs = []
["slf4j-jdk14-#{node["solr"]["slf4j"]["version"]}.jar", "log4j-over-slf4j-#{node["solr"]["slf4j"]["version"]}.jar", "slf4j-api-#{node["solr"]["slf4j"]["version"]}.jar", "jcl-over-slf4j-#{node["solr"]["slf4j"]["version"]}.jar"].each do |file|
  execute "extract #{file}" do
    command "tar -xzvf /tmp/slf4j-#{node["solr"]["slf4j"]["version"]}.tar.gz -C /tmp/ slf4j-#{node["solr"]["slf4j"]["version"]}/#{file}"
    creates "/tmp/slf4j-#{node["solr"]["slf4j"]["version"]}/#{file}"
  end
libs << "file:///tmp/slf4j-#{node["solr"]["slf4j"]["version"]}/#{file}"
end
node.set["solr"]["lib_uri"] = libs

# Extract war file from solr archive
solr_url = "#{node["solr"]["url"]}#{node["solr"]["version"]}/solr-#{node["solr"]["version"]}.tgz"
remote_file "solr_src" do
  path "/tmp/solr-#{node["solr"]["version"]}.tgz"
  source solr_url
  action :create_if_missing
end

execute "extract solr_src" do
  command "tar -xzvf /tmp/solr-#{node["solr"]["version"]}.tgz -C /tmp"
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

node.set["solr"]["war_uri"] = "#{node["solr"]["path"]}/webapps/solr.war"

#create solr/cores dir
directory "#{node["solr"]["path"]}/cores" do
  owner "#{node["tomcat"]["user"]}"
  group "#{node["tomcat"]["user"]}"
  mode "00755"
  action :create
end
#create cores config

template "#{node["solr"]["path"]}/cores/solr.xml" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr.xml.erb"
end

execute "ln home" do
  command "ln -sf #{node["solr"]["path"]} #{node["tomcat"]["base"]}/solr"
end

execute "change solr owner" do
  command "chown -R #{node["tomcat"]["user"]}:#{node["tomcat"]["group"]} #{node["solr"]["path"]}"
end
