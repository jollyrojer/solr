#default["solr"]["url"] = "http://apache.mesi.com.ar/lucene/solr/"
default["solr"]["url"] = "http://archive.apache.org/dist/lucene/solr/"
default["solr"]["version"] = "4.6.0"
default["solr"]["path"] = "/opt/solr"
#default["solr"]["slf4j"]["url"] = "http://www.slf4j.org/dist"
#default["solr"]["slf4j"]["version"] = "1.6.6"
default["solr"]["collection"] = []
default["solr"]["zookeeper"]["port"] = "2181"
default["solr"]["zookeeper"]["timeout"] = "10000" 
default["solr"]["zookeeper"]["hosts"] = []
if (! node["solr"]["zookeeper"]["hosts"].empty?)
  zoo_nodes = []
  node["solr"]["zookeeper"]["hosts"].each do |zoonode|
    zoo_nodes << "#{zoonode}:#{node["solr"]["zookeeper"]["port"]}"
  end
  set["solr"]["zookeeper"]["nodes"] = zoo_nodes.join(",")
else
  set["solr"]["zookeeper"]["nodes"] = ""
end

default["solr"]["port"]="8983"
default["solr"]["hostcontext"]="solr"
default["solr"]["logdir"]="#{node["solr"]["path"]}/logs"
default["solr"]["loglevel"]="INFO"
default["solr"]["zookeeper"]["loglevel"]="WARN"
default["solr"]["hadoop"]["loglevel"]="WARN"
default["tomcat"]["base_version"] = 6
case node['platform']
when "centos","redhat","fedora"
  default["tomcat"]["user"] = "tomcat"
  default["tomcat"]["group"] = "tomcat"
  default["tomcat"]["base"] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
when "debian","ubuntu"
  default["tomcat"]["user"] = "tomcat#{node["tomcat"]["base_version"]}"
  default["tomcat"]["group"] = "tomcat#{node["tomcat"]["base_version"]}"
  default["tomcat"]["base"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}"
end
