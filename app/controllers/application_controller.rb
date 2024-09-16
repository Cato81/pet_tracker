class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from PetTypeService::InvalidPetType, with: :invalid_pet_type

  private

  def render_error(code, message, status, details = nil)
    render json: {
      error: {
        code: code,
        message: message,
        details: details
      }
    }, status: status
  end
  
  def record_not_found(exception)
    render_error('404', 'The requested resource does not exist', :not_found, exception&.message)
  end
  
  def invalid_pet_type(exception)
    render_error('422', 'The pet type is not valid', :unprocessable_entity , exception&.message)
  end
end
