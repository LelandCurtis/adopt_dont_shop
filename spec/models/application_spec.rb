require 'rails_helper'

RSpec.describe Application, type: :model do
  it {should have_many(:pet_applications)}
  it {should have_many(:pets).through(:pet_applications)}

  before :each do
    @shelter = Shelter.create!(foster_program: true, name: "shelter_1", city: "Dallas", rank: 1)

    @pet_1 = Pet.create!(adoptable: true, age: 10, breed: "Hound", name: "Pete", shelter_id: @shelter.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "GSP", name: "Newton", shelter_id: @shelter.id)
    @pet_3 = Pet.create!(adoptable: true, age: 13, breed: "German Shepard", name: "Molly", shelter_id: @shelter.id)


    @application_1 = Application.create(name: 'Steve', address: '135 Waddle Road', city: 'Dallas', state: 'TX', zip: 75001, description: "I really want a dog", status: "Pending")

    @pet_application_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_1.id)
    @pet_application_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @application_1.id)
    @pet_application_3 = PetApplication.create!(pet_id: @pet_3.id, application_id: @application_1.id)
  end

  describe '.check_status' do
    it 'returns "Pending" if any pet_application is "In Progress"' do
      expect(@application_1.check_status).to eq("Pending")
    end

    it 'returns "Approved" if all pet_applications are is "Approved"' do
      expect(@application_1.check_status).to eq("Pending")
      @pet_application_1.update(status: "Approved")
      @pet_application_2.update(status: "Approved")
      expect(@application_1.check_status).to eq("Pending")
      @pet_application_3.update(status: "Approved")
      expect(@application_1.check_status).to eq("Approved")
    end

    it 'returns "Rejected" if any pet_application is "Rejected"' do
      expect(@application_1.check_status).to eq("Pending")
      @pet_application_1.update(status: "Approved")
      @pet_application_2.update(status: "Rejected")
      expect(@application_1.check_status).to eq("Pending")
      @pet_application_3.update(status: "Approved")
      expect(@application_1.check_status).to eq("Rejected")
    end
  end
end
