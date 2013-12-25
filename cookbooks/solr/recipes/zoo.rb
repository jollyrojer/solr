
#create zkcli
template "#{node["solr"]["path"]}/webapps/zkcli.sh" do
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 00755
  source "zkcli.sh.erb"
  variables({
    :solr_src => "/opt/solr-#{node["solr"]["version"]}/example/cloud-scripts"
  })
end

#populate zookeeper
zoo_connect = "#{node["solr"]["zookeeper"]["host"]}:#{node["solr"]["zookeeper"]["port"]}"
solr_cores = "#{node["solr"]["path"]}/cores"
node["solr"]["collection"].each do |collection|
  execute "upload zoo collection #{collection}" do
    command "sudo #{node["solr"]["path"]}/webapps/zkcli.sh -cmd upconfig -zkhost #{zoo_connect} -d #{solr_cores}/#{collection}/conf/ -n #{collection}"
  end

  execute "link zoo collection #{collection}" do
    command "sudo #{node["solr"]["path"]}/webapps/zkcli.sh -cmd linkconfig -zkhost #{zoo_connect} -collection #{collection} -confname #{collection} -solrhome #{solr_cores}"
  end

  execute "bootstrap zoo collection #{collection}" do
    command "sudo #{node["solr"]["path"]}/webapps/zkcli.sh -cmd bootstrap -zkhost #{zoo_connect} -solrhome #{solr_cores}"
  end
end

