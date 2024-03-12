class User < ApplicationRecord
    attr_accessor :remember_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    has_secure_password
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 50 }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, confirmation: { case_sensitive: true }
    validates :password_confirmation, presence: true
    
    before_save { email.downcase! }

    class << self
        def digest token
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(token, cost: cost)
        end

        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    def remember 
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    def session_token
        remember_digest || remember
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?

        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_column(:remember_digest, nil)
    end
end
