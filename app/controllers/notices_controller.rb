class NoticesController < ApplicationController
  before_action :permission_required!, only: %i[index show]

  before_action :set_notice,
                only: %i[show edit publish update destroy validate create_validation confirmation create_confirmation]

  # GET /notices or /notices.json
  def index
    @notices = notice_scope.revised

    if params[:admin].present?
      @notices = notice_scope.unrevised.includes(:ad_type, :creator)
    end

    if params[:ad_type_id].present?
      @notices = @notices.where(ad_type_id: params[:ad_type_id])
    end

    if params[:order_by] == 'rating'

      @notices = @notices.with_average_rating
    elsif params[:order_by] == 'date'
      @notices = @notices.order_by_fields_date
    end

    if params[:search].present?
      search_terms = params[:search].split(/\s+/)
      @notices = @notices.search_by_terms(search_terms)
    end

    unless params[:order_by] == 'rating'
      @pagy, @notices = pagy(@notices)
    end
  end

  # GET /notices/1 or /notices/1.json
  def show; end

  def validate
    @notice.invoiceable_gid = current_user.to_global_id
  end

  def confirmation; end

  # GET /notices/new
  def new
    @notice = notice_scope.new
    @ocr_text = params[:ocr_text]
  end

  def fields
    @ad_type = AdType.find(params[:ad_type_id])

    @notice = Notice.new(ad_type: @ad_type)
    @ad_type.ad_type_fields.each do |field|
      @notice.notice_values.build(ad_type_field: field)
    end

    head(:no_content) and return unless @ad_type

    respond_to do |format|
      format.turbo_stream do
        render(
          turbo_stream: turbo_stream.update('field_values_container',
                                            partial: 'notices/fields',
                                            locals: { notice: @notice })
        )
      end
    end
  rescue ActiveRecord::RecordNotFound
    head(:no_content)
  end

  # GET /notices/1/edit
  def edit
  end

  # POST /notices or /notices.json
  def create
    @notice = notice_scope.new(notice_params)

    @notice.ad_type_stage = @notice&.ad_type&.ad_type_stages&.first
    @notice.creator = current_user
    respond_to do |format|
      if @notice.save
        format.html { redirect_to [:validate, @notice] }
        format.json { render :show, status: :created, location: @notice }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_notice_form', partial: "notices/form", locals: { notice: @notice }) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notices/1 or /notices/1.json
  def update
    respond_to do |format|
      if @notice.update(notice_params)
        NoticeUpdateNotification.with(notice_id: @notice.id, user_name: @notice.creator.name).deliver_later(User.where(admin: true))
        format.html { redirect_to [:validate, @notice] }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_notice_form', partial: "notices/form", locals: { notice: @notice }) }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create_validation
    respond_to do |format|
      if @notice.update(validate_notice_params)
        format.html { redirect_to [:confirmation, @notice] }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('notice_validation_container', template: "notices/validate") }
        format.html { render :validate, status: :unprocessable_entity }
      end
    end
  end

  def create_confirmation
    @notice.sent!
    redirect_to root_path, notice: 'Anunțul a fost trimis spre aprobare.'
  end

  def publish
    @notice.update(status: :revised)
    respond_to do |format|
      if @notice.save
        format.html { redirect_to root_path, notice: 'Anunțul a fost publicat cu succes!' }
        format.json { head :no_content }
      else
        # Default response to avoid UnknownFormat errors
        format.any { render plain: 'Unsupported format', status: :not_acceptable }
      end
    end
  end


  # DELETE /notices/1 or /notices/1.json
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to notices_url, notice: "Anunțul a fost șters!" }
      format.json { head :no_content }
    end
  end

  private

  def set_notice
    @notice = notice_scope.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:ad_type_id, :observation, :description, notice_values_attributes: %i[id value file ad_type_field_id])
  end

  def validate_notice_params
    params.require(:notice).permit(:invoiceable_gid, :buy_electronic, :buy_hardcopy)
  end

  def permission_required!
    current_user.permission?(:can_validate_ad)
  end

  def notice_scope
    if current_user.permission?(:can_validate_ad)
      Notice.all
    else
      current_user.created_notices
    end
  end
end
