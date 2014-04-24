require 'minitest/spec'

def assert_include_content(file, content)
  assert File.read(file).include?(content), "Expected file '#{file}' to include the specified content #{content}"
end

describe_recipe "solr::create_collection" do
  it "creates collection folder" do
    node["solr"]["collection"].each do |collection|
      assert_directory "#{node["solr"]["path"]}/cores/#{collection}", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "755"
    end
  end
  it "creates collection config folder" do
    node["solr"]["collection"].each do |collection|
      assert_directory "#{node["solr"]["path"]}/cores/#{collection}/conf", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "755"
    end
  end
  it "creates collection schema.xml" do
    node["solr"]["collection"].each do |collection|
      assert_file "#{node["solr"]["path"]}/cores/#{collection}/conf/schema.xml", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "600"
    end
  end
  it "creates collection solrconfig.xml" do
    node["solr"]["collection"].each do |collection|
      assert_file "#{node["solr"]["path"]}/cores/#{collection}/conf/solrconfig.xml", "#{node["tomcat"]["user"]}", "#{node["tomcat"]["user"]}", "600"
    end
  end
  it "add to schema.xml correct values" do
    node["solr"]["collection"].each do |collection|
      assert_include_content("#{node["solr"]["path"]}/cores/#{collection}/conf/schema.xml", "#{collection}")
    end
  end
  it "add to solrconfig.xml correct values" do
    node["solr"]["collection"].each do |collection|
      assert_include_content("#{node["solr"]["path"]}/cores/#{collection}/conf/solrconfig.xml", "#{collection}")
    end
  end
  it "add to solr.xml correct values" do
    node["solr"]["collection"].each do |collection|
      assert_include_content("#{node["solr"]["path"]}/cores/solr.xml", "core name=\"#{collection}\" instanceDir=\"#{collection}\"")
    end
  end
end
