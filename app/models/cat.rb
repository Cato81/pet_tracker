class Cat < Pet
  after_initialize :set_pet_type

  validates :tracker_type, 
            inclusion: {
              in:  %w(small big),
              message: "%{value} is not valid type of tracker for a Cat"
            }

  private

  def set_pet_type
    self.type = 'Cat'
  end
end
