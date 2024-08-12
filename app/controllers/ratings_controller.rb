class RatingsController < ApplicationController
  before_action :set_rating, only: %i[show edit update destroy validate create_validation confirmation create_confirmation]
  before_action :set_notice, only: %i[create]

  def create
    @rating = current_user.ratings.new(rating_params)
    @rating.notice = @notice

    if !@rating.save
      flash[:notice] = @rating.errors.full_messages.to_sentence
    else
      flash[:notice] = 'Rating-ul a fost creat cu succes'
    end

    redirect_to @notice
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def set_notice
    @notice = Notice.find(params[:notice_id])
  end

  def rating_params
    params.require(:rating).permit(:rating, :notice_id)
  end
end
