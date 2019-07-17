Given /^the "([^"]*)" gem is installed$/ do |gem|
  if gem == 'qat'
    destination_folder = ::File.join('gems', "#{gem}-10.0.0.testing")
    lib_folder         = ::File.join(destination_folder, 'lib')
    create_directory lib_folder
    copy ::File.join('..', '..', '..', 'lib'), destination_folder
    prepend_environment_variable('RUBYLIB', "#{File.join aruba.root_directory, aruba.current_directory, lib_folder}:")
  end
end