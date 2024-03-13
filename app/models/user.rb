class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    has_secure_password
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 50 }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, confirmation: { case_sensitive: true }
    validates :password_confirmation, presence: true
    
    before_save { email.downcase! }
    before_save :create_activation_digest

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
        update_column(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end

    def session_token
        remember_digest || remember
    end

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?

        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_column(:remember_digest, nil)
    end

    def send_activation_email
        UserMailer.acount_activation(self.diliver_later)
    end

    def activate_account
        update(is_activated: true, activated_at: Time.zone.now)
    end
end
