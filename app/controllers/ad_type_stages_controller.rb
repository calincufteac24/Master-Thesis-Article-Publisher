class AdTypeStagesController < ApplicationController
  before_action :set_ad_type_stage, only: %i[ show edit update destroy ]

  # GET /ad_type_stages or /ad_type_stages.json
  def index
    @ad_type_stages = AdTypeStage.all
  end

  # GET /ad_type_stages/1 or /ad_type_stages/1.json
  def show
  end

  # GET /ad_type_stages/new
  def new
    @ad_type_stage = AdTypeStage.new
  end

  # GET /ad_type_stages/1/edit
  def edit
  end

  # POST /ad_type_stages or /ad_type_stages.json
  def create
    @ad_type_stage = AdTypeStage.new(ad_type_stage_params)

    respond_to do |format|
      if @ad_type_stage.save
        format.html { redirect_to @ad_type_stage, notice: "Ad type stage was successfully created." }
        format.json { render :show, status: :created, location: @ad_type_stage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ad_type_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_type_stages/1 or /ad_type_stages/1.json
  def update
    respond_to do |format|
      if @ad_type_stage.update(ad_type_stage_params)
        format.html { redirect_to @ad_type_stage, notice: "Ad type stage was successfully updated." }
        format.json { render :show, status: :ok, location: @ad_type_stage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ad_type_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_type_stages/1 or /ad_type_stages/1.json
  def destroy
    @ad_type_stage.destroy
    respond_to do |format|
      format.html { redirect_to ad_type_stages_url, notice: "Ad type stage was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_type_stage
      @ad_type_stage = AdTypeStage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ad_type_stage_params
      params.require(:ad_type_stage).permit(:ad_type_id, :stage_id, :position, :create_invoice)
    end
end
