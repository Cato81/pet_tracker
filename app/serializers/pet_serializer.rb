class PetSerializer < ActiveModel::Serializer
  attributes :id, :type, :tracker_type, :owner_id, :in_zone 
  attribute :lost_tracker, if: :cat?

  def cat?
    object.type == 'Cat' && object.lost_tracker
  end
end
