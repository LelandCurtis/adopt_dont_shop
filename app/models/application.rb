class Application < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true, numericality: true
  validates_length_of :zip, is: 5
  validates :status, presence: true
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

  def approve
    update(status: "Approved")
    pets.each do |pet|
      pet.update(adoptable: false)
    end
  end

  def reject
    update(status: "Rejected")
  end

  def update_status
    if status != check_status
      if check_status == "Approved"
        approve
      else
        reject
      end
    end
  end
end
