class PetTypeService
  class InvalidPetType < StandardError; end
  
  PET_TYPES = {
    'cat' => Cat,
    'dog' => Dog
  }.freeze
  
  attr_reader :pet_type

  def initialize(pet_type)
    @pet_type = pet_type.downcase
  end

  def call
    PET_TYPES[pet_type] ||= raise InvalidPetType, "Invalid pet type `#{pet_type}`" 
  end
end
