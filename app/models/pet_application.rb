class PetApplication <ApplicationRecord
  validates :status, presence: true
  belongs_to :pet
  belongs_to :application
  has_one :shelter, through: :pet

  def already_approved?
    PetApplication.joins(:application).exists?(applications: {status: "Approved"}, pet_applications: {pet_id: pet_id})
  end

  def self.pending
    where(status: "Pending")
  end
end
