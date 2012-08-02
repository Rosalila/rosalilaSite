class Article < ActiveRecord::Base
  attr_accessible :content, :title, :user_id, :image
	belongs_to :user
	has_attached_file :image#, :styles => { :medium => "300x300>" }
	validates_attachment :image, :size => { :in => 0..1.megabytes }
	validates_presence_of :content, :title
end
