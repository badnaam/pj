desc "Remove image files after they are destroyed"
task :delete_images do |t, args|
    image_path = "#{RAILS_ROOT}/public/assets/images/" + args.imageible_name.pluralize + File::SEPARATOR + args.image_id + File::SEPARATOR
    Dir.foreach(image_path){|file| File.delete(image_path+file) if (/^.*.jpg$/).match(file)} if File.exist?(image_path)
    Dir.rmdir(image_path)
end

desc "Says Hello"
task :say_hello, [:name] do |t, args|
    puts "hello " + args.name
end