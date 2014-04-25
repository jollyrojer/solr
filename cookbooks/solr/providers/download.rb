action :download_extract do
  version = new_resource.ver
  url = new_resource.url
  checksum = new_resource.checksum

  bash "get solr-src" do
    cwd "/tmp"
    code <<-EOH
        wget "#{url}"
        tar -zxvf /tmp/solr-#{version}.tgz -C /tmp  
      EOH
  end
end
