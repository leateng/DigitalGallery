# encoding: utf-8

desc 'build apk for client'
task :build_apk => [:environment] do
  android_project_path = ENV["ANDROID_PROJECT_PATH"]
  assets_dir = "#{android_project_path}/app/src/main/assets"
  release_dir = "#{android_project_path}/app/build/outputs/apk/release"
  helloar_path = "#{android_project_path}/app/src/main/java/cn/moosao/digitalstudio/HelloAR.java"

  User.find_each do |user|
    targets = user.targets_json
    next if targets["images"].size == 0
    puts user.name

    # clean assets dir
    system("rm #{assets_dir}/*")
    system("rm #{release_dir}/*") if File.exist?(release_dir)

    # copy new assets
    user.images.each_with_index do |image, index|
      if image.video_id.present?
        system("copy #{image.content.path} #{assets_dir}/#{index}.jpg")
        system("copy #{image.relate_video.content.path} #{assets_dir}/#{index}.mp4")
      end
    end

    # generate targets.json
    File.open("#{assets_dir}/targets.json", "w+"){ |f| f.write user.targets_json.to_json }

    # build release apk
    Dir.chdir(android_project_dir)
    system("gradle build")

    # replace code `int imageSize = 0`
    content = File.read(helloar_path)
    content.gsub!(/int imageSize = \d+;/, "int imageSize = #{targets["images"].size};")
    File.open(helloar_path, "w+"){|f| f.write content}

    # upload apk to user
    if File.exist?("#{release_dir}/app-release.apk")
      File.open("#{release_dir}/app-release.apk", "rb") do |f|
        user.app = f
        user.save
      end
    end
  end
end