class FixFollowerIdColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :relationships, :folower_id, :follower_id
  end
end
