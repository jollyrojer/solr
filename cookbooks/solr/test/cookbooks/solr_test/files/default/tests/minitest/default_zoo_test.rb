require 'minitest/spec'

def assert_include_content(file, content)
  assert File.read(file).include?(content), "Expected file '#{file}' to include the specified content #{content}"
end

describe_recipe "solr::default" do
  it "creates solr_src folder" do
    assert File.directory?("/tmp/solr-#{node['solr']['version']}")
  end
  it "creates webapp folder" do
    assert_directory "#{node["solr"]["path"]}/webapps", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "755"
  end
  it "copy solr.war to to webapps" do
    assert_file "#{node["solr"]["path"]}/webapps/solr.war", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "644"
  end
  it "creates solr cores folder" do
    assert_directory "#{node["solr"]["path"]}/cores", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "755"
  end
  it "creates solr cores config solr.xml" do
    assert_file "#{node["solr"]["path"]}/cores/solr.xml", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "600"
  end
  it "check cores config solr.xml correct" do
    assert_include_content("#{node["solr"]["path"]}/cores/solr.xml", "hostPort=\"#{node["solr"]["port"]}\"")
    assert_include_content("#{node["solr"]["path"]}/cores/solr.xml", "hostContext=\"#{node["solr"]["hostcontext"]}\"")
    assert_include_content("#{node["solr"]["path"]}/cores/solr.xml", "zkHost=\"#{node["solr"]["zookeeper"]["nodes"]}\"")
    assert_include_content("#{node["solr"]["path"]}/cores/solr.xml", "zkClientTimeout=\"#{node["solr"]["zookeeper"]["timeout"]}\"")
  end
  it "creates solr log dir" do
    assert_directory "#{node["solr"]["logdir"]}", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "755"
  end
  it "creates log4j config" do
    assert_file "#{node["solr"]["path"]}/webapps/log4j.properties", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "600"
  end
  it "check log4j config correct" do
    assert_include_content("#{node["solr"]["path"]}/webapps/log4j.properties", "#{node["solr"]["logdir"]}")
    assert_include_content("#{node["solr"]["path"]}/webapps/log4j.properties", "#{node["solr"]["loglevel"]}")
    assert_include_content("#{node["solr"]["path"]}/webapps/log4j.properties", "#{node["solr"]["zookeeper"]["loglevel"]}")
    assert_include_content("#{node["solr"]["path"]}/webapps/log4j.properties", "#{node["solr"]["hadoop"]["loglevel"]}")
  end
end
