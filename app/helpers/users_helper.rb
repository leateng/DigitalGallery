module UsersHelper
  def gravatar_for(user, klass="gravatar")
    #gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    #gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    gravatar_url = user.gravatar.thumb.url || "default_avatar.jpg"
    image_tag gravatar_url, alt: user.name, class: klass
  end

  def label_for(user)
    label_class =
        case user.role
        when "admin"
         "label-warning"
        when "operator"
          "label-info"
        else
          "label-success"
        end

    content_tag "span", user.role, class: "label #{label_class}"
  end
end
