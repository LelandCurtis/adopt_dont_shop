class Admin::PetApplicationsController < ApplicationController
  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(pet_app_params)
    redirect_to "/admin/applications/#{pet_application.application.id}"
  end

  private

  def pet_app_params
    params.permit(:pet_id, :application_id, :status)
  end
end
