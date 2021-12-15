require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
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
end
