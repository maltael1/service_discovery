class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    drop_breadcumbs :services, service_variants_path
    @services = Service.all
  end

  def show
    drop_breadcumbs :service_variants, service_variants_path
    drop_breadcumbs  @service.service_variant.name, service_variant_path( @service.service_variant)
    drop_breadcumbs :services
    drop_breadcumbs @service.id, service_path(@service.id)
  end

  def edit
    drop_breadcumbs :service_variants, services_path
    drop_breadcumbs  @service.service_variant.name, service_variant_path( @service.service_variant)
    drop_breadcumbs :services
    drop_breadcumbs @service.id, service_path(@service.id)
    drop_breadcumbs :edit
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_path, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:service_variant_id, :status_cd, :host, :code, :token)
  end
end
