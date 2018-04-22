module ApplicationHelper
  def full_title(name = '')
    base = '魔扫'
    if name.blank?
      base
    else
      "#{name} | #{base}"
    end
  end
end
