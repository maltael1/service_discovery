class ServiceVariantsController < ApplicationController
  before_action :set_service_variant, only: [:show, :edit, :update, :destroy]

  def index
    drop_breadcumbs :service_variants, service_variants_path
    @service_variants = ServiceVariant.all
  end

  def show
    drop_breadcumbs :service_variants, service_variants_path
    drop_breadcumbs @service_variant.name, service_variant_path(@service_variant)
  end

  def new
    drop_breadcumbs :service_variants, service_variants_path
    drop_breadcumbs :new
    @service_variant = ServiceVariant.new
  end

  def edit
    drop_breadcumbs :service_variants, service_variants_path
    drop_breadcumbs @service_variant.name, service_variant_path(@service_variant)
    drop_breadcumbs :edit
  end

  def create
    @service_variant = ServiceVariant.new(service_variant_params)

    respond_to do |format|
      if @service_variant.save
        format.html { redirect_to @service_variant, notice: 'Service variant was successfully created.' }
        format.json { render :show, status: :created, location: @service_variant }
      else
        format.html { render :new }
        format.json { render json: @service_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service_variant.update(service_variant_params)
        format.html { redirect_to @service_variant, notice: 'Service variant was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_variant }
      else
        format.html { render :edit }
        format.json { render json: @service_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service_variant.destroy
    respond_to do |format|
      format.html { redirect_to service_variants_url, notice: 'Service variant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_service_variant
      @service_variant = ServiceVariant.find(params[:id])
    end

    def service_variant_params
      params.require(:service_variant).permit(:name, :code)
    end
end
