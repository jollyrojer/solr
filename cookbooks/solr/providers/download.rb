action :download_extract do
  version = new_resource.ver
  url = new_resource.url
  checksum = new_resource.checksum
  remote_file "solr_src" do
    path "/tmp/solr-#{version}.tgz"
    source "#{url}"
    checksum "#{checksum}"
    action :create_if_missing
  end
          
  execute "extract solr_src" do
    command "tar -xzvf /tmp/solr-#{version}.tgz -C /tmp"
    creates "/tmp/solr-#{version}"
  end
end
