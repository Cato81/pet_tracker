require 'rails_helper'

RSpec.describe Cat, type: :model do
  describe 'validations' do
    it 'should be valid with valid attributes' do
      cat = Cat.new(tracker_type: 'small', owner_id: 1)
      
      expect(cat).to be_valid
    end

    it 'should be invalid with incorrect tracker_type' do
      cat = Cat.new(tracker_type: 'InvalidType', owner_id: 1)
      
      expect(cat).not_to be_valid
      expect(cat.errors[:tracker_type]).to eq(["InvalidType is not valid type of tracker for a Cat"])
    end
  end

  describe '#initialize' do
    context 'when pet type is not passed' do
      it 'should set the pet type' do
        cat = Cat.create(tracker_type: 'small', owner_id: 1, in_zone: true )

        expect(cat.type).to eq 'Cat'
      end
    end
  end
end
