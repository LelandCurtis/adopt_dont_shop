require 'rails_helper'

RSpec.describe 'admin shelter index page' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @pet_1 = Pet.create!(adoptable: true, age: 10, breed: "Hound", name: "Pete", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "GSP", name: "Newton", shelter_id: @shelter_2.id)
    @pet_3 = Pet.create!(adoptable: true, age: 13, breed: "German Shepard", name: "Molly", shelter_id: @shelter_3.id)
    @pet_4 = Pet.create!(adoptable: true, age: 13, breed: "German Shepard", name: "Molly", shelter_id: @shelter_1.id)
    @application_1 = Application.create!(name: 'Steve', address: '135 Waddle Road', city: 'Dallas', state: 'TX', zip: 75001, description: "I really want a dog", status: "Pending")
    @pet_application_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_1.id)
    @pet_application_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @application_1.id)
    @pet_application_4 = PetApplication.create!(pet_id: @pet_4.id, application_id: @application_1.id)

  end

  it 'lists all the shelters in reverse alphabetical order when in admin mode' do
    visit '/admin/shelters'
    within('div.shelters') do
      expect(@shelter_2.name).to appear_before(@shelter_1.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  it 'has a section that lists only shelters with pending applications and they are listed alphabetically' do
    visit '/admin/shelters'
    expect(page).to have_content("Shelters with Pending Applications")

    within('div.pending') do
      expect(@shelter_1.name).to appear_before(@shelter_2.name)
    end
  end

  it 'each name is a link to the show page' do
    visit '/admin/shelters'

    within('div.shelters') do
      click_link "#{@shelter_1.name}"
      expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")
    end

    visit '/admin/shelters'

    within('div.pending') do
      click_link "#{@shelter_1.name}"
      expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")
    end
  end
end
