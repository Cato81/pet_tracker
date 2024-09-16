class PetsController < ApplicationController
  def index
    render json: Pet.all
  end
  
  def create
    pet_type = PetTypeService.new(pet_params[:type]).call
    @pet = pet_type.new(pet_params)

    if pet.save
      render json: pet, status: :created
    else
      render json: { status: '422', errors: pet.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: pet
  end

  def update
    if pet_params[:type]
      pet_class = PetTypeService.new(pet_params[:type]).call
      @pet = pet_class.find(params[:id])
    end

    if pet.update(pet_params)
      render json: pet, status: :ok
    else
      render json: { status: '422', errors: pet.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if pet.destroy!
      head :no_content
    else
      render json: { status: '422', errors: pet.errors }, status: :unprocessable_entity
    end
  end

  def off_zone
    off_zone_pets = OffZoneService.new.call

    render json: off_zone_pets, except: [:created_at, :updated_at]
  end

  private

  def pet
    @pet ||= Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end
end
