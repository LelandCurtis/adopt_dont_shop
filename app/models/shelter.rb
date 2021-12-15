class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adoptable_pet_count
    adoptable_pets.count
  end

  def adopted_pet_count
    pets.joins(:applications)
        .where(applications: {status: "Approved"})
        .count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.order_by_name_desc
    Shelter.find_by_sql(
      "SELECT * FROM shelters
      ORDER BY name DESC"
    )
  end

  def self.order_by_name_asc
    Shelter.order(:name)
  end

  def self.with_pending_applications
    Shelter.select("shelters.*")
    .joins(:pets => {:pet_applications => :application})
    .where(applications: {status: 'Pending'})
    .group("shelters.id")
  end

  def self.sql_name(id)
    Shelter.find_by_sql(
      "SELECT name FROM shelters
      WHERE id = #{id}"
    )[0].name
  end

  def self.sql_city(id)
    Shelter.find_by_sql(
      "SELECT city FROM shelters
      WHERE id = #{id}"
    )[0].city
  end

  def avg_age
    pets.where(adoptable: true).average(:age).round(2)
  end
end
