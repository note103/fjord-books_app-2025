# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  before_action :set_report

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user

    @comment.save! # 現在の設計上、保存失敗は想定しておらず、起きた場合は例外で検知したいため save! メソッドを使用
    redirect_to @report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
