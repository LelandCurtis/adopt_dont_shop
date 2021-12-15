require 'rails_helper'

RSpec.describe 'admin shelters show page' do
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
    @pet_application_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_1.id, status: "Approved")
    @pet_application_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @application_1.id, status: "Rejected")
    @pet_application_4 = PetApplication.create!(pet_id: @pet_4.id, application_id: @application_1.id, status: "Pending")
  end

  it 'shows each shelter name and full address' do
    visit "/admin/shelters/#{@shelter_1.id}"

    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_1.city)
  end

  it 'has a section for statistics that shows the average age of all adoptable pets in that shelter.' do
    visit "/admin/shelters/#{@shelter_1.id}"

    within 'div.statistics' do
      expect(page).to have_content("Average age of adoptable pets in this shelter is #{@shelter_1.avg_age}")
    end
  end

  it 'shows the number of adoptable pets in statistics section' do
    visit "/admin/shelters/#{@shelter_1.id}"

    within 'div.statistics' do
      expect(page).to have_content("There are #{@shelter_1.adoptable_pet_count} adoptable pets in this shelter")
    end
  end

  it 'shows the number of pets that have been adopted in the statistics section' do
    visit "/admin/shelters/#{@shelter_1.id}"

    within 'div.statistics' do
      expect(page).to have_content("#{@shelter_1.adopted_pet_count} pets have been adopted from this shelter")
    end
  end

  it "in the action required section I see a list of all pets for this shelter that have a pending application and have not yet been marked approved or rejected" do
    visit "/admin/shelters/#{@shelter_1.id}"

    within 'div.action_required' do
      expect(page).to have_content(@pet_4.name)
      expect(page).to_not have_content(@pet_1.name)
      expect(page).to_not have_content(@pet_2.name)
    end
  end

  it "in the action required section all pets have a link to their corresponding pending application" do
    visit "/admin/shelters/#{@shelter_1.id}"

    within "div.pet_app_#{@pet_application_4.id}" do
      click_link "here"
      expect(current_path).to eq("/admin/applications/#{@pet_application_4.id}")
    end
  end
end
