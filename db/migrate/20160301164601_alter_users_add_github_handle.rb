class AlterUsersAddGithubHandle < ActiveRecord::Migration
  def change
    add_column :users, :github_handle, :string
  end
end
