class UserPermissionsController < ApplicationController
  before_action :set_user

  def create
    respond_to do |format|
      @user_permission = @user.user_permissions.build(create_params)

      if @user_permission.save
        format.turbo_stream
        format.html { redirect_to [:edit, @user], notice: 'Permission was successfully created.' }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user_permission, partial: 'user_permissions/form', locals: { user_permission: @user_permission }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_permission = @user.user_permissions.find(params[:id])
    @user_permission.destroy

    respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@user_permission) }
        format.html { redirect_to [:edit, @user], notice: 'Permission was successfully destroyed.' }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def create_params
    params.require(:user_permission).permit(:permission)
  end
end
