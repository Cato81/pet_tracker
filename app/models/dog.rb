class Dog < Pet
  after_initialize :set_pet_type
  before_validation :ensure_lost_tracker_false

  validates :tracker_type, 
            inclusion: {
              in:  %w(small medium big),
              message: "%{value} is not valid type of tracker for a Dog"
            }

  private

  def set_pet_type
    self.type = 'Dog'
  end

  def ensure_lost_tracker_false
    return unless lost_tracker
    
    errors.add(:lost_tracker, 'Cannot set lost tracker for a Dog')
  end
end
