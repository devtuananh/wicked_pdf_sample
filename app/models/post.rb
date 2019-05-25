class Post < ActiveRecord::Base
  mount_uploader :attach, AttachUploader

  validates :name, presence: true
  validates :title, presence: true
end
