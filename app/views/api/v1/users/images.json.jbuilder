json.array! @images do |image|
  json.id image.id
  json.name image.content.file.filename
  json.type image.content_type

  if Rails.env.development?
    json.thumb_url ("http://192.168.0.115:4000" + image.thumb_url)
    json.url ("http://192.168.0.115:4000" + image.content.url)
  else
    json.thumb_url ("http://www.moosao.cn:3000" + image.thumb_url)
    json.url ("http://www.moosao.cn:3000" + image.content.url)
  end

  json.meta_info image.meta_info
  json.created_at image.created_at
end