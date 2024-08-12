class UsersController < ApplicationController
  before_action :permission_required!
  before_action :set_user, only: %i[show edit destroy update approve photo]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @user.update user_params
        format.html { redirect_to @user, notice: 'Datele Utilizatorului a fost actualizat.' }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, template: "users/edit") }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @user.approved!
    redirect_to user_path(@user), notice: 'Utilizatorul a fost aprobat'
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Utilizatorul a fost șters.' }
      format.json { head :no_content }
    end
  end

  def photo
    user_personal_information = @user.user_personal_information
    if user_personal_information&.photo&.attached?
      send_data user_personal_information.photo.download, type: user_personal_information.photo.content_type, disposition: 'inline'
    else
      head :not_found
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :role, user_permission_permissions: [])
  end

  def permission_required!
    current_user.permission?(:manage_users)
  end
end
