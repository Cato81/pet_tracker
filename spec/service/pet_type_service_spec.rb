require 'rails_helper'

RSpec.describe PetTypeService, type: :model do
  describe '#call' do
    context 'when pet type is valid' do
      let(:service) {  PetTypeService.new('cat') }
      
      it 'should return given class' do
        expect(service.call).to eq Cat 
      end
    end
    
    context 'when pet type is invalid' do
      let(:service) {  PetTypeService.new('worm') }
      
      it 'should return given class' do
        expect { service.call }.to raise_error(PetTypeService::InvalidPetType, 'Invalid pet type `worm`')
      end
    end
  end
end
