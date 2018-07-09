# encoding: utf-8

desc 'build apk for client'
task :build_apk => [:environment] do
  android_project_path = ENV["ANDROID_PROJECT_PATH"]
  assets_dir = "#{android_project_path}/app/src/main/assets"
  raw_dir = "#{android_project_path}/app/src/main/res/raw"
  release_dir = "#{android_project_path}/app/build/outputs/apk/release"
  helloar_path = "#{android_project_path}/app/src/main/java/cn/moosao/digitalstudio/HelloAR.java"

  User.clients.find_each do |user|
    targets = user.targets_json
    next if targets["images"].size == 0
    puts user.name

    # clean assets dir
    system("rm #{assets_dir}/*.jpg")
    system("rm #{raw_dir}/*.mp4")
    system("rm #{release_dir}/*.apk") if File.exist?(release_dir)

    # copy new assets
    user.images.each_with_index do |image, index|
      if image.video_id.present?
        system("cp #{image.content.path} #{assets_dir}/#{index}.jpg")
        system("cp #{image.relate_video.content.path} #{raw_dir}/video#{index}.mp4")
      end
    end

    # generate targets.json
    File.open("#{assets_dir}/targets.json", "w+"){ |f| f.write user.targets_json.to_json }

    # build release apk
    Dir.chdir(android_project_path)
    system("gradle build")

    # replace code `int imageSize = 0`
    content = File.read(helloar_path)
    content.gsub!(/int imageSize = \d+;/, "int imageSize = #{targets["images"].size};")
    File.open(helloar_path, "w+"){|f| f.write content}

    # upload apk to user
    if File.exist?("#{release_dir}/app-release.apk")
      File.open("#{release_dir}/app-release.apk", "rb") do |f|
        user.update_attribute(:app, f)
      end
    end
  end
end