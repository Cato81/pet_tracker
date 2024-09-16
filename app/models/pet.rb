class Pet < ApplicationRecord
  validates :tracker_type, :owner_id, presence: true
  scope :out_off_zone, -> { where(in_zone: false) }
end
