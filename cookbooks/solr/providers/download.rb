action :download_extract do
remote_file "solr_src" do
  path "/tmp/solr-#{@new_resource.version}"
  source "#{@new_resource.solr_url}"
  checksum "#{@new_resource.solr_checksum}"
  action :create_if_missing
end
          
execute "extract solr_src" do
  command "tar -xzvf /tmp/solr-#{@new_resource.version}.tgz -C /tmp"
  creates "/tmp/solr-#{@new_resource.version}"
  end
end
