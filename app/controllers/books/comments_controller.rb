# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_book

  def create
    @comment = @book.comments.build(comment_params)
    @comment.user = current_user

    @comment.save! # 現在の設計上、保存失敗は想定しておらず、起きた場合は例外で検知したいため save! メソッドを使用
    redirect_to @book, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
