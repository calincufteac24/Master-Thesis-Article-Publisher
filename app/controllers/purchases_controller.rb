class PurchasesController < ApplicationController
  before_action :set_notice
  def new; end

  private

  def set_notice
    @notice = Notice.find(params[:notice_id])
  end
end
