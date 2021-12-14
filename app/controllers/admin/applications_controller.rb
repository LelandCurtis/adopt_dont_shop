class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])

    # check if application status is different than pet_applications would suggest
    # if so, make necessary updates to application and pets
    @application.update_status
  end
end
