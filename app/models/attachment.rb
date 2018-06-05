class Attachment < ApplicationRecord
  mount_uploader :content, ::AttachmentUploader
  serialize :meta_info, Hash
  belongs_to :user
  #belongs_to :create_by, class_name: "User", foreign_key: "create_by"

  before_save :extract_meta_info
  before_save :set_content_type
  after_save :generate_video_thumb
  after_destroy :delete_thumb


  def creator
    User.find(creator_id)
  end

  def generate_video_thumb
    movie = FFMPEG::Movie.new(self.content.path)
    movie.screenshot(video_thumb_path, seek_time: 3, resolution: "320x240")
  end

  def extract_meta_info
    case content.content_type
    when /.*jpeg/
      image = MiniMagick::Image.open(self.content.path)
      self.meta_info = {
          height: image.height,
          width: image.width,
          size: image.size,
      }
    when /.*mp4/
      movie = FFMPEG::Movie.new(self.content.path)
      self.meta_info = {
          height: movie.height,
          width: movie.width,
          duration: movie.duration,
          size: movie.size
      }
    else
      self.meta_info = {}
    end
  end

  def set_content_type
    case self.content.content_type
    when /.*jpeg/i
      self.content_type = "jpeg"
    when /.*mp4/i
      self.content_type = "mp4"
    else
      self.content_type = self.content.content_type
    end
  end

  def image?
    content_type == "jpeg"
  end

  def video?
    content_type == "mp4"
  end

  def meta_info_str
    str = "#{self.meta_info[:width]}x#{self.meta_info[:height]} #{(self.meta_info[:size].to_f / 1024 / 1024).round(2)}M"
    str += " #{self.meta_info[:duration].to_i}s" if self.video?
    str
  end

  def thumb_url
    if image?
      content.thumb.url
    elsif video?
      video_thumb_url
    else
      "/default_video_thumb.jpg"
    end
  end

  def thumb_path
    if self.video?
      video_thumb_path
    else
      self.content.thumb.path
    end
  end

  def video_thumb_path
    video_path = content.path
    File.join(File.dirname(video_path), File.basename(video_path).split('.').first + ".jpg")
  end

  def video_thumb_url
    video_url = content.url
    File.join(File.dirname(video_url), File.basename(video_url).split('.').first + ".jpg")
  end

  def delete_thumb
    FileUtils.rm(thumb_path) if File.exist?(thumb_path)
  end

  def relate_video
    self.class.where(id: video_id).first
  end
end
