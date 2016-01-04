class AddOpengraphFieldsToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :og_title, :string
    add_column :posts, :og_description, :string
    add_column :posts, :og_url, :string
    add_column :posts, :og_image, :string
  end
  def down
    remove_column :posts, :og_title, :string
    remove_column :posts, :og_description, :string
    remove_column :posts, :og_url, :string
    remove_column :posts, :og_image, :string
  end
end
