#
# Delete collection
#

solr_cores = "#{node["solr"]["path"]}/cores"

if (! node["solr"]["zookeeper"]["nodes"].empty?)
#clean zoo
  zoo_connect = "#{node["solr"]["zookeeper"]["nodes"]}"
  bash "clean zookeeper data" do
    user "root"
    code <<-EOH
    #{node["solr"]["path"]}/webapps/zkcli.sh -zkhost #{zoo_connect} -cmd clear /
    EOH
  end
end
#delete collection in cores
bash "delete solr collection" do
  user "root"
  code <<-EOH
  rm -rf #{solr_cores}/*
  EOH
end
