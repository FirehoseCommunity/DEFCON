class AddNameAndNotificationTypeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :notification_type, :string, default: "Posts and Comments"
    add_column :users, :name, :string, default: "I Am Awesome"
  end
  def down
    remove_column :users, :notification_type, :string
    remove_column :users, :name, :string
  end
end
