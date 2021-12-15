class ApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @pets = Pet.search(params[:search])
    end
  end

  def new
  end

  def create
    application = Application.new(application_params)

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:notice] = "Error: Invalid application. Please try again."
      flash[:alert] = application.errors.full_messages
      render :new
    end
  end

  def edit
    @application = Application.find(params[:id])
    @application.update(application_params)
    redirect_to "/applications/#{@application.id}"
  end


  private

  def application_params
    params.permit(:name,
                  :address,
                  :city,
                  :state,
                  :zip_code,
                  :description,
                  :status)
  end
end
