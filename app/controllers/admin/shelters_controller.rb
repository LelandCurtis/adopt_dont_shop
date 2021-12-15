class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_desc
    @pending_shelters = Shelter.with_pending_applications
  end

  def show
    @sql_shelter_name = Shelter.sql_name(params[:id])
    @sql_shelter_address = Shelter.sql_address(params[:id])
  end
end
