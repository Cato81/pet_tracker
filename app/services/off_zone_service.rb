class OffZoneService
  def call
    {
      pets_off_zone: total_pets_off_zone,
      cats_off_zone: cats_off_zone_count,
      dogs_off_zone: dogs_off_zone_count,
      cats: cats_data,
      dogs: dogs_data
    }
  end

  private

  def total_pets_off_zone
    cats.count + dogs.count
  end

  def cats_off_zone_count
    cats.count
  end

  def dogs_off_zone_count
    dogs.count
  end

  def cats_data
    cats.group_by(&:tracker_type)
  end

  def dogs_data
    dogs.group_by(&:tracker_type)
  end

  def cats
    @cats ||= Cat.out_off_zone
  end

  def dogs
    @dogs ||= Dog.out_off_zone
  end
end
