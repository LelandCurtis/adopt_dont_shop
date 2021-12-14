class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def check_status
    pet_applications
  end
end
