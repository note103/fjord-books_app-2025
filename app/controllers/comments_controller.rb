# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    if params[:book_id]
      @book = Book.find(params[:book_id])
      commentable = @book
    elsif params[:report_id]
      @report = Report.find(params[:report_id])
      commentable = @report
    end
    @comment = commentable.comments.build(comment_params)
    @comment.user = current_user

    return redirect_to commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) if @comment.save

    if commentable.is_a?(Book)
      render 'books/show', status: :unprocessable_entity
    else
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    commentable = comment.commentable
    comment.destroy! # 現在の設計上、削除失敗は想定しておらず、起きた場合は例外で検知したいため destroy! メソッドを使用
    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
