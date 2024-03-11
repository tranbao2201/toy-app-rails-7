class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    has_secure_password
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }, confirmation: { case_sensitive: true }
    validates :password_confirmation, presence: true
    
    before_save { email.downcase! }
end
