module DigestMethod
    extend ActiveSupport::Concern

    included do
        #create method create_activation_digest, create_reset_digest
        self::CREATE_DIGEST_ATTRIBUTE.each do |attribute|
            attribute_digest = "#{attribute}_digest"
            attribute_token = "#{attribute}_token"
            define_method("create_#{attribute_digest}") do
                self._assign_attribute(attribute_token, User.new_token)
                update_column(attribute_digest, User.digest(attribute_token))
                update_column(:reset_send_at, Time.zone.now) if attribute == :reset
            end
        end
    end
end