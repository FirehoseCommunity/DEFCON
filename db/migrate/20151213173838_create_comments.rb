class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :message

      t.integer :user_id
      t.integer :post_id
      t.timestamps
    end

    add_index :comments, [:user_id, :post_id]
    add_index :comments, :post_id
  end
end