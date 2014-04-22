#
# Cookbook Name:: solr-component
# Recipe:: update_zoo_collections
#
#
zoo_connect = "#{node["solr"]["zookeeper"]["nodes"]}"
solr_cores = "#{node["solr"]["path"]}/cores"

if (! node["solr"]["zookeeper"]["nodes"].empty?)
#clean zoo
  bash "clean zookeeper data" do
    user "root"
    code <<-EOH
    #{node["solr"]["path"]}/webapps/zkcli.sh -zkhost #{zoo_connect} -cmd clear /
    EOH
  end
end


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
