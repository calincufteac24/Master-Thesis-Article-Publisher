class CommentsController < ApplicationController
  before_action :set_comment,
                only: %i[show edit update destroy validate create_validation confirmation create_confirmation]
  def create
    @comment = current_user.comments.new(comment_params)
    if !@comment.save
      flash[:notice] = @comment.errors.full_messages.to_sentece
    else
      flash[:notice] = 'Comentariul a fost creat cu success'
    end


    redirect_to root_path
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to notice_path(@comment.notice)
      flash[:notice] = 'Comentariul a fost modificat cu success'
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to notice_path(@comment.notice), notice: "Comentariul a fost șters." }
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :notice_id)
  end
end
