action :download_extract do
remote_file "solr_src" do
  path "/tmp/solr-#{@new_resource.ver}"
  source "#{@new_resource.url}"
  checksum "#{@new_resource.checksum}"
  action :create_if_missing
end
          
execute "extract solr_src" do
  command "tar -xzvf /tmp/solr-#{@new_resource.ver}.tgz -C /tmp"
  creates "/tmp/solr-#{@new_resource.ver}"
  end
end
