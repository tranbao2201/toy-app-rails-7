class AddActivationDigestToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
    add_column :users, :activation_digest, :string
  end
end
