require 'rails_helper'

RSpec.describe Pet, type: :model do
  it { should validate_presence_of(:tracker_type) }
  it { should validate_presence_of(:owner_id) }
end
