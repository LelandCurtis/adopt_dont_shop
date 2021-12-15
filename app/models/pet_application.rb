class PetApplication <ApplicationRecord
  belongs_to :pet
  belongs_to :application

  # def already_approved?
  #   approved_pet_apps = PetApplication.joins(:application)
  #                                     .where(applications: {status: "Approved"}, pet_applications: {pet_id: pet_id})
  #   if approved_pet_apps.count > 0
  #     return true
  #   else
  #     return false
  #   end
  # end
  def already_approved?
    PetApplication.joins(:application).exists?(applications: {status: "Approved"}, pet_applications: {pet_id: pet_id})
  end
end
