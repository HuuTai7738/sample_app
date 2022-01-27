module RelationshipsHelper
  def load_follow_user user
    current_user.active_relationships.find_by followed_id: user.id
  end
end
