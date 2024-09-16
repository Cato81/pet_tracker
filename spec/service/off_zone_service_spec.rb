require 'rails_helper'

RSpec.describe OffZoneService, type: :model do
  describe '#call' do
    let(:service) { OffZoneService.new }
    let(:expected_structure) do
      {
        pets_off_zone: 3,
        cats_off_zone: 2,
        dogs_off_zone: 1,
        cats: {
          "small" => Cat.where(tracker_type: 'small', in_zone: false),
          "big" => Cat.where(tracker_type: 'big', in_zone: false)
        },
        dogs: {
          "small" =>  Dog.where(tracker_type: 'small', in_zone: false)
        }
      }
    end
    
    before do
      Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false)
      Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true)
      Pet.create(type: 'Cat', tracker_type: 'big', owner_id: 1, in_zone: false)
      Pet.create(type: 'Dog', tracker_type: 'small', owner_id: 1, in_zone: false)
    end
    
    it 'should create proper structure' do
      expect(service.call).to eq expected_structure
    end
  end
end
