class ServiceRegistrationsController < ApplicationController
  before_action :set_service_registration, only: [:show, :edit, :update, :destroy]

  # GET /service_registrations
  # GET /service_registrations.json
  def index
    @service_registrations = ServiceRegistration.all
  end

  # GET /service_registrations/1
  # GET /service_registrations/1.json
  def show
  end

  # GET /service_registrations/new
  def new
    @service_registration = ServiceRegistration.new
  end

  # GET /service_registrations/1/edit
  def edit
  end

  # POST /service_registrations
  # POST /service_registrations.json
  def create
    @service_registration = ServiceRegistration.new(service_registration_params)

    respond_to do |format|
      if @service_registration.save
        format.html { redirect_to @service_registration, notice: 'Service registration was successfully created.' }
        format.json { render :show, status: :created, location: @service_registration }
      else
        format.html { render :new }
        format.json { render json: @service_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_registrations/1
  # PATCH/PUT /service_registrations/1.json
  def update
    respond_to do |format|
      if @service_registration.update(service_registration_params)
        format.html { redirect_to @service_registration, notice: 'Service registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_registration }
      else
        format.html { render :edit }
        format.json { render json: @service_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_registrations/1
  # DELETE /service_registrations/1.json
  def destroy
    @service_registration.destroy
    respond_to do |format|
      format.html { redirect_to service_registrations_url, notice: 'Service registration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_registration
      @service_registration = ServiceRegistration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_registration_params
      params.require(:service_registration).permit(:service_id, :status_cd, :host, :code, :token)
    end
end
