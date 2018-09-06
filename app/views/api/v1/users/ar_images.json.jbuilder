json.array! @images do |image|
  json.id image.id
  json.name image.content.file.filename
  json.type image.content_type
  json.thumb_url(ENV['API_HOST'] + image.thumb_url)
  json.url(ENV['API_HOST'] + image.content.url)
  json.meta_info image.meta_info
  json.created_at image.created_at

  json.video_name image.video.content.file.filename
  json.video_thumb_url(ENV['API_HOST'] + image.video.thumb_url)
  json.video_url(ENV['API_HOST'] + image.video.content.url)
  json.video_meta_info image.video.meta_info
end