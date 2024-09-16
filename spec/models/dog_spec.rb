require 'rails_helper'

RSpec.describe Dog, type: :model do  
  describe 'validations' do
    it 'should be valid with valid attributes' do
      dog = Dog.new(tracker_type: 'small', owner_id: 1)
      
      expect(dog).to be_valid
    end

    it 'should be invalid with invalid tracker_type' do
      dog = Dog.new(tracker_type: 'InvalidType', owner_id: 1)
      
      expect(dog).not_to be_valid
      expect(dog.errors[:tracker_type]).to eq(["InvalidType is not valid type of tracker for a Dog"])
    end

    it 'should be invalid if lost_tracker is true' do
      dog = Dog.new(tracker_type: 'small', owner_id: 1, lost_tracker: true)

      expect(dog).not_to be_valid
      expect(dog.errors[:lost_tracker]).to eq(["Cannot set lost tracker for a Dog"])
    end
  end

  describe '#initialize' do
    context 'when pet type is not passed' do
      it 'should set the pet type' do
        dog = Dog.create(tracker_type: 'small', owner_id: 1, in_zone: true )

        expect(dog.type).to eq 'Dog'
      end
    end
  end
end
