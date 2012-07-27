class User < ActiveRecord::Base
	# Para los campos de la form en new.html.erb  
	attr_accessible :username, :email, :password, :password_confirmation
	attr_accessor :password
	before_save :encrypt_password # encripta la pass enviada
  validates_confirmation_of :password

	validates_presence_of :password, :on => :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username
	before_create { generate_token(:auth_token) } # genera el token antes de crear el user

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end
	
	# Usado al crear la session de log_in
	def self.authenticate(login, password)
    user = find_by_email(login)
		if user == nil
			user = find_by_username(login)
		end
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
	end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end
end
