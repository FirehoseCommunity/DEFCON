class AddNameAndNotificationTypeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :post_notification, :boolean, default: true
    add_column :users, :comment_notification, :boolean, default: true
    add_column :users, :name, :string, default: "I Am Awesome"
  end
  def down
    remove_column :users, :post_notification, :boolean
    remove_column :users, :comment_notification, :boolean
    remove_column :users, :name, :string
  end
end
