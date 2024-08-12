class AdTypeFieldsController < ApplicationController
  before_action :set_ad_type
  before_action :set_ad_type_field, only: %i[ show edit update destroy ]

  # GET /ad_type_fields or /ad_type_fields.json
  def index
    @ad_type_fields = @ad_type.ad_type_fields
  end

  # GET /ad_type_fields/1 or /ad_type_fields/1.json
  def show
  end

  # GET /ad_type_fields/new
  def new
    @ad_type_field = @ad_type.ad_type_fields.build
  end

  # GET /ad_type_fields/1/edit
  def edit
  end

  # POST /ad_type_fields or /ad_type_fields.json
  def create
    @ad_type_field = @ad_type.ad_type_fields.new(ad_type_field_params)

    respond_to do |format|
      if @ad_type_field.save
        format.html { redirect_to @ad_type, notice: "Ad type field was successfully created." }
        format.json { render :show, status: :created, location: @ad_type_field }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ad_type_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_type_fields/1 or /ad_type_fields/1.json
  def update
    respond_to do |format|
      if @ad_type_field.update(ad_type_field_params)
        format.html { redirect_to @ad_type, notice: "Câmpul a fost actualizat cu succes" }
        format.json { render :show, status: :ok, location: @ad_type_field }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ad_type_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_type_fields/1 or /ad_type_fields/1.json
  def destroy
    @ad_type_field.destroy
    respond_to do |format|
      format.html { redirect_to ad_type_fields_url, notice: "Ad type field was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ad_type_field
    @ad_type_field = @ad_type.ad_type_fields.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def ad_type_field_params
    params.require(:ad_type_field).permit(:name, :ad_type_id, :form_field_type, :help_text, :text_before, :text_after, :required, :position, option_values: [])
  end

  def set_ad_type
    @ad_type = AdType.find(params[:ad_type_id])
  end
end
