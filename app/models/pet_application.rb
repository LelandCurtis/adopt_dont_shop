class PetApplication <ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def already_approved?
    approved_pet_apps = PetApplication.all
                                      .join(:applications)
                                      .where(applications: {status: "Approved"}, pet_applications: {pet_id: pet_id})
    if approved_pet_apps.count > 0
      true
    else
      false
    end
  end
end
