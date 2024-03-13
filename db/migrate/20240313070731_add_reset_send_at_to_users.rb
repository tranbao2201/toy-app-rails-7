class AddResetSendAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_send_at, :datetime
  end
end
