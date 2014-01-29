# Support whyrun
def whyrun_supported?
  true
end

action :run do
	converge_by("Replace #{@new_resource}") do
	  file_path = @new_resource.path || @new_resource.name
	  replace_regex = Regexp.new(@new_resource.replace)
	  replace_with = (@new_resource.with or '')
		ruby_block "#{@new_resource.name}" do
			block do
				file = Chef::Util::FileEdit.new(file_path)
				file.search_file_replace(
					replace_regex,
					replace_with
				)
				file.write_file
			end
			only_if { ::File.read(file_path) =~ replace_regex }
		end
	end
end
