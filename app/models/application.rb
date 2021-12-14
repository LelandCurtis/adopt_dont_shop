class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def check_status
    # Logic assumes valid data. Only In Progress, Approved, or Rejected exist.
    # If any are in progress, return In Progress
    # Else no In Progress exist, if any rejected exists, return rejected
    # Only available option left is no In Progress / no Rejected, therefore all Accepted.
    if pet_applications.exists?(status: "Pending")
      "Pending"
    elsif pet_applications.exists?(status: "Rejected")
      "Rejected"
    else
      "Approved"
    end
  end
end
