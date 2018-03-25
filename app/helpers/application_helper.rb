module ApplicationHelper
  def full_title(name = '')
    base = 'Ruby on Rails Tutorial Sample App'
    if name.blank?
      base
    else
      "#{name} | #{base}"
    end
  end
end
