require 'rails_helper'

RSpec.describe 'admin show page' do
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

  it 'lists all pets applied for' do
    visit "/admin/applications/#{@application_1.id}"

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_content(@pet_2.name)
    expect(page).to have_content(@pet_3.name)
  end

  it 'has an approve and reject button next to all open pets' do
    visit "/admin/applications/#{@application_1.id}"

    within("div.pet_#{@pet_application_1.id}") do
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'has accept and reject buttons that update the pet_application status' do
    visit "/admin/applications/#{@application_1.id}"

    within("div.pet_#{@pet_application_1.id}") do
      expect(@pet_application_1.status).to eq("Pending")
      click_button "Approve"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(PetApplication.find(@pet_application_1.id).status).to eq("Approved")
      expect(page).to_not have_button("Approve")
      expect(page).to have_content("Approved")
    end

    within("div.pet_#{@pet_application_2.id}") do
      expect(@pet_application_2.status).to eq("Pending")
      click_button "Reject"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(PetApplication.find(@pet_application_2.id).status).to eq("Rejected")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end
  end

  it 'show page checks pet_application status and adjusts application status to accepted if all are marked accepted' do
    visit "/admin/applications/#{@application_1.id}"

    expect(@application_1.status).to eq("Pending")
    within("div.pet_#{@pet_application_1.id}") do
      click_button "Approve"
    end
    expect(@application_1.status).to eq("Pending")

    within("div.pet_#{@pet_application_2.id}") do
      click_button "Approve"
    end
    expect(@application_1.status).to eq("Pending")

    within("div.pet_#{@pet_application_3.id}") do
      click_button "Approve"
    end
    expect(@application_1.status).to eq("Approved")
  end

  it 'show page checks pet_application status and adjusts application status to Rejected if any are marked rejected' do
    visit "/admin/applications/#{@application_1.id}"

    expect(@application_1.status).to eq("Pending")
    within("div.pet_#{@pet_application_1.id}") do
      click_button "Approve"
    end
    expect(@application_1.status).to eq("Pending")

    within("div.pet_#{@pet_application_2.id}") do
      click_button "Reject"
    end
    expect(@application_1.status).to eq("Pending")

    within("div.pet_#{@pet_application_3.id}") do
      click_button "Approve"
    end
    expect(@application_1.status).to eq("Rejected")
  end
end
