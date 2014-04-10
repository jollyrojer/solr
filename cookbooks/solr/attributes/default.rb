#default["solr"]["url"] = "http://apache.mesi.com.ar/lucene/solr/"
default["solr"]["url"] = "http://archive.apache.org/dist/lucene/solr/"
default["solr"]["version"] = "4.6.0"
default["solr"]["checksum"]["4.1.0"] = "763b316a88fd5a61e4004c02eea813647c8ffc4201d0aa1db04deccc58b264bc"
default["solr"]["checksum"]["4.2.0"] = "6929d06fafea1a8b1a3e2dcee0ca4afd93db7dd9333468977aa4347da01db7ed"
default["solr"]["checksum"]["4.2.1"] = "648a4b2509f6bcac83554ca5958cf607474e81f34e6ed3a0bc932ea7fac40b99"
default["solr"]["checksum"]["4.3.0"] = "b28240167ce6dd6a957c548ea6085486a4d27a02a643c4812a6d4528778ea9b7"
default["solr"]["checksum"]["4.3.1"] = "99c27527122fdc0d6eba83ced9598bf5cd3584954188b32cb2f655f1e810886b"
default["solr"]["checksum"]["4.4.0"] = "f188313f89ac53229d0b89e35391facd18774e6f708803151e50ba61bbe18906"
default["solr"]["checksum"]["4.5.0"] = "8f53f9a317cbb2f0c8304ecf32aa3b8c9a11b5947270ba8d1d6372764d46f781"
default["solr"]["checksum"]["4.5.1"] = "8726fa10c6b92aa1d2235768092ee2d4cd486eea1738695f91b33c3fd8bc4bd7"
default["solr"]["checksum"]["4.6.0"] = "2a4a6559665363236653bec749f580a5da973e1088227ceb1fca87802bd06a3f"
default["solr"]["checksum"]["4.6.1"] = "5ee861d7ae301c0f3fa1e96e4cb42469531d8f9188d477351404561b47e55d94"
default["solr"]["checksum"]["4.7.0"] = "ac131fbc60f4f539173aa2155e941c389d0b19cbcef1d8016d5d6277a1bda362"
default["solr"]["checksum"]["4.7.1"] = "4a546369a31d34b15bc4b99188984716bf4c0c158c0e337f3c1f98088aec70ee"
default["solr"]["path"] = "/opt/solr"
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
