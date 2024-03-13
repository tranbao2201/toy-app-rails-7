class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    has_secure_password
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 50 }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, confirmation: { case_sensitive: true }
    validates :password_confirmation, presence: true
    
    before_save { email.downcase! }
    after_save :create_activation_digest

    has_many :microposts, dependent: :destroy

    default_scope -> { order(created_at: :desc) }

    CREATE_DIGEST_ATTRIBUTE = %i(activation reset)

    class << self
        def digest token
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(token, cost: cost)
        end

        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    #create method create_activation_digest, create_reset_digest
    CREATE_DIGEST_ATTRIBUTE.each do |attribute|
        attribute_digest = "#{attribute}_digest"
        attribute_token = "#{attribute}_token"
        define_method("create_#{attribute_digest}") do
            self._assign_attribute(attribute_token, User.new_token)
            update_column(attribute_digest, User.digest(attribute_token))
            update_column(:reset_send_at, Time.zone.now) if attribute == :reset
        end
    end

    def remember 
        self.remember_token = User.new_token
        update_column(:remember_digest, User.digest(remember_token))
        remember_digest
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
        UserMailer.acount_activation(self).deliver_now
    end

    def activate_account
        update(is_activated: true, activated_at: Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def reset_is_expired?
        reset_send_at < 2.hours.ago
    end
end
