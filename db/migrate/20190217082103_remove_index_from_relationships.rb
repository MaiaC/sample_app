class RemoveIndexFromRelationships < ActiveRecord::Migration[5.2]
  def change
    remove_index :relationships, name: "index_relationships_on_follower_id_and_followed_id"
  end
end
