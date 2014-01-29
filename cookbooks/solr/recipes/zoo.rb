#
# Cookbook Name:: solr-component
# Recipe:: zoo
#
package "unzip" do
  action :install
end

execute "extract solr_war" do
  command "unzip -o #{node["solr"]["path"]}/webapps/solr.war -d /tmp/solr_war"
  action :run
end

#create zkcli
template "#{node["solr"]["path"]}/webapps/zkcli.sh" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 00755
  source "zkcli.sh.erb"
  variables({
    :solr_src => "/tmp/solr-#{node["solr"]["version"]}/example/cloud-scripts"
  })
end

#populate zookeeper
zoo_connect = "#{node["solr"]["zookeeper"]["nodes"]}"
solr_cores = "#{node["solr"]["path"]}/cores"

bash "upload collections to zoo" do
  user "root"
  code <<-EOH
  for collection in $(find #{solr_cores} -maxdepth 1 -mindepth 1 -type d -exec basename {} \\;) ; do
    #{node["solr"]["path"]}/webapps/zkcli.sh -cmd upconfig -zkhost #{zoo_connect} -d #{solr_cores}/$collection/conf/ -n $collection
    #{node["solr"]["path"]}/webapps/zkcli.sh -cmd linkconfig -zkhost #{zoo_connect} -collection $collection -confname $collection -solrhome #{solr_cores}
    #{node["solr"]["path"]}/webapps/zkcli.sh -cmd bootstrap -zkhost #{zoo_connect} -solrhome #{solr_cores}
  done
  EOH
end
