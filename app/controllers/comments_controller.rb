# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    comment = current_user.comments.find(params[:id])
    commentable = comment.commentable
    comment.destroy! # 現在の設計上、削除失敗は想定しておらず、起きた場合は例外で検知したいため destroy! メソッドを使用
    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end
end
