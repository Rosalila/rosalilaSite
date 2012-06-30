class User < ActiveRecord::Base
	# Para los campos de la form en new.html.erb  
	attr_accessible :email, :password, :password_confirmation
	attr_accessor :password
	before_save :encrypt_password # encripta la pass enviada
  validates_confirmation_of :password

	validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end
end
