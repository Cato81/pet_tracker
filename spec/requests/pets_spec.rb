require 'rails_helper'

RSpec.describe Pet, type: :request do
  let(:pet) { Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true ) }
  let(:payload) do
    {
      pet:
      {
        type: 'Cat',
        tracker_type: 'small',
        owner_id: 1,
        in_zone: true
      }
    }
  end
  
  describe 'POST /pets' do
    context 'when request is valid' do
      before do
        post '/pets', params: payload
      end

      it 'should create a pet' do
        expect { post '/pets', params: payload }.to change(Pet, :count).by(1)
      end
      
      it 'should return success' do
        expect(response).to have_http_status :created
      end
      
      it 'should return created object' do
        response_object = JSON.parse(response.body).with_indifferent_access

        expect(response_object[:type]).to eq payload[:pet][:type]
        expect(response_object[:tracker_type]).to eq payload[:pet][:tracker_type]
        expect(response_object[:owner_id]).to eq payload[:pet][:owner_id]
        expect(response_object[:in_zone]).to eq payload[:pet][:in_zone]
      end
    end

    context 'when request is invalid' do
      before do
        payload[:pet][:tracker_type] = 'medium'
        post '/pets', params: payload
      end

      it 'should return unprocessable entity error' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return error message' do
        errors = JSON.parse(response.body)

        expect(errors['errors']['tracker_type']).to include 'medium is not valid type of tracker for a Cat'
      end
    end
  end

  describe 'GET /pets' do
    context 'when data exists' do
      before do
        2.times { Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true ) }

        get '/pets'
      end

      it 'should return success' do
        expect(response).to have_http_status :ok
      end

      it 'should return all pets' do
        response_object = JSON.parse(response.body)
        
        expect(response_object.count).to eq 2
      end
    end

    context 'when there is no records' do
      before do
        get '/pets'
      end

      it 'should return empty body' do
        response_object = JSON.parse(response.body)

        expect(response_object).to eq([])
      end
    end
  end
  
  describe 'GET /pets/:id' do
    context 'when data exists' do
      before do
        pet
        get "/pets/#{pet.id}"
      end

      it 'should return success' do
        expect(response).to have_http_status :ok
      end

      it 'should return given pet' do
        response_object = JSON.parse(response.body).with_indifferent_access
  
        expect(response_object[:type]).to eq pet.type
        expect(response_object[:tracker_type]).to eq pet.tracker_type
        expect(response_object[:owner_id]).to eq pet.owner_id
        expect(response_object[:in_zone]).to eq pet.in_zone
      end
    end

    context 'when there is no requested record' do
      before do
        get "/pets/dunno"
      end

      it 'should return not found error' do
        expect(response).to have_http_status :not_found
      end

      it 'should return error message' do
        errors = JSON.parse(response.body)

        expect(errors['error']['message']).to include('The requested resource does not exist')
      end
    end
  end

  describe 'PATCH /pets/:id' do
    context 'when valid request' do
      before do
        patch "/pets/#{pet.id}", params: { pet:{ type: 'Cat', lost_tracker: true }}
      end

      it 'should return success' do
        expect(response).to have_http_status :ok
      end

      it 'should return updated pet object' do
        response_object = JSON.parse(response.body).with_indifferent_access
  
        expect(response_object).to include(lost_tracker: true)
        expect(response_object[:type]).to eq payload[:pet][:type]
        expect(response_object[:tracker_type]).to eq payload[:pet][:tracker_type]
        expect(response_object[:owner_id]).to eq payload[:pet][:owner_id]
        expect(response_object[:in_zone]).to eq payload[:pet][:in_zone]
      end
    end

    context 'when invalid request' do
      context 'with pet type is invalid' do
        before do
          patch "/pets/#{pet.id}", params: { pet: { type: 'Horse' }}
        end
        
        it 'should not be success' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'should return an error message' do
          response_object = JSON.parse(response.body).with_indifferent_access
          
          expect(response_object[:error][:message]).to eq('The pet type is not valid')
          expect(response_object[:error][:details]).to eq('Invalid pet type `horse`')
        end
      end
    end

    context 'when record does not exist' do
      before do
        patch '/pets/dunno', params: { pet: { type: 'Cat', in_zone: false }}
      end

      it 'should return not found error' do
        expect(response).to have_http_status :not_found
      end

      it 'should return error message' do
        errors = JSON.parse(response.body)

        expect(errors['error']['message']).to include('The requested resource does not exist')
      end
    end
  end

  describe 'GET /pets/off_zone' do
    before do
      Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false)
      Pet.create(type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true)
      Pet.create(type: 'Cat', tracker_type: 'big', owner_id: 1, in_zone: false)
      Pet.create(type: 'Dog', tracker_type: 'small', owner_id: 1, in_zone: false)
      
      get '/pets/off_zone'
    end

    it 'should return success' do
      expect(response).to have_http_status :ok
    end

    it 'should return all out off zone pets' do
      response_object = JSON.parse(response.body).with_indifferent_access
      
      expect(response_object[:pets_off_zone]).to eq 3
      expect(response_object[:cats_off_zone]).to eq 2
      expect(response_object[:dogs_off_zone]).to eq 1
      expect(response_object[:cats][:small].count).to eq 1
      expect(response_object[:cats][:big].count).to eq 1
      expect(response_object[:dogs][:small].count).to eq 1
    end
  end
end
