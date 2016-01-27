class AddPostInteractionNotificationToUsers < ActiveRecord::Migration
  def up
    add_column :users, :post_interaction_notification, :boolean, default: true
  end
  def down
    remove_column :users, :post_interaction_notification, :boolean
  end
end
