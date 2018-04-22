json.array! @images do |image|
  json.id image.id
  json.name image.content.file.filename
  json.type image.content_type
  json.thumb_url image.thumb_url
  json.url image.content.url
  json.meta_info image.meta_info
  json.created_at image.created_at
end