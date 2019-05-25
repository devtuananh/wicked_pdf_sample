module ApplicationHelper
  def custom_bootstrap_flash
    flash_messages = []
    option = "{'closeButton': true}"
    flash.each do |type, message|
      type = "success" if type == "notice"
      type = "error" if type == "alert"
      type = "warning" if type == "warning"
      text = "toastr.#{type}('#{message}', '', #{option});"
      flash_messages << text if message
    end
    flash_messages.join("\n")
  end

  def check_image_extension content_type
    extension = %w(image/jpg image/jpeg image/png image/gif)
    extension.include? content_type
  end

  def check_video_extension content_type
    extension = %w(video/mp4)
    extension.include? content_type
  end

  require 'docx'
  def read file
    doc = Docx::Document.open('file')
    doc.paragraphs.each do |p|
      puts p.to_html
    end
  end
end
