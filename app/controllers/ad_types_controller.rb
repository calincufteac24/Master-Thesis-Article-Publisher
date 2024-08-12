class AdTypesController < ApplicationController
  before_action :set_ad_type, only: %i[ show edit update destroy ]

  # GET /ad_types or /ad_types.json
  def index
    @ad_types = Category.all
    @categories = Category.primary
  end

  # GET /ad_types/1 or /ad_types/1.json
  def show
  end

  # GET /ad_types/new
  def new
    @ad_type = AdType.new
  end

  # GET /ad_types/1/edit
  def edit
  end

  # POST /ad_types or /ad_types.json
  def create
    @ad_type = AdType.new(ad_type_params)

    respond_to do |format|
      if @ad_type.save
        format.html { redirect_to @ad_type, notice: "Ad type was successfully created." }
        format.json { render :show, status: :created, location: @ad_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ad_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_types/1 or /ad_types/1.json
  def update
    respond_to do |format|
      if @ad_type.update(ad_type_params)
        format.html { redirect_to @ad_type, notice: "Ad type was successfully updated." }
        format.json { render :show, status: :ok, location: @ad_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ad_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_types/1 or /ad_types/1.json
  def destroy
    @ad_type.destroy
    respond_to do |format|
      format.html { redirect_to ad_types_url, notice: "Ad type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_type
      @ad_type = AdType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ad_type_params
      params.require(:ad_type).permit(:name, :description, :about, :category_id)
    end
end
