class PetApplicationsController < ApplicationController
  def create
    PetApplication.create(pet_id: params[:pet_id], application_id: params[:application_id])
    redirect_to("/applications/#{params[:application_id]}")
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(pet_app_params)
  end

  private

  def pet_app_params
    params.permit(:pet_id, :application_id, :status)
  end
end
