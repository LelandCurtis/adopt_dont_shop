require 'rails_helper'

RSpec.describe PetApplication, type: :model do
  it {should belong_to(:pet)}
  it {should belong_to(:application)}

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

  describe "already_approved?" do
    it "returns true if the pet has another approved application. False if it does not." do
      application_2 = Application.create(name: 'Steve', address: '135 Waddle Road', city: 'Dallas', state: 'TX', zip: 75001, description: "I really want a dog", status: "Approved")
      pet_application_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: application_2.id, status: "Approved")

      expect(@pet_application_1.already_approved?).to eq(true)
      expect(@pet_application_2.already_approved?).to eq(false)
    end
  end

  describe '#pending' do
    it 'returns all the pet_applications where the status is pending' do
      pet_application_4 = PetApplication.create!(pet_id: @pet_2.id, application_id: @application_1.id, status: "Approved")
      pet_application_5 = PetApplication.create!(pet_id: @pet_3.id, application_id: @application_1.id, status: "Rejected")
      expect(PetApplication.pending).to eq([@pet_application_1, @pet_application_2, @pet_application_3])
    end
  end
end
