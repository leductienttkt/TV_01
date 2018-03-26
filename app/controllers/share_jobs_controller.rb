class ShareJobsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_job, only: [:create, :destroy]

  def create
    share_job = @job.share current_user
    if share_job.save
      message = t ".share_success"
      status = 200
    else
      message = t ".share_fail"
      status = 400
    end
    render_json message, status
  end

  def destroy
    if @job.unshare current_user
      message = t ".unshare_success"
      status = 200
    else
      message = t ".unshare_fail"
      status = 400
    end
    render_json message, status
  end

  private

  def load_job
    @job = Job.find_by(id: params[:id]) if params[:id]
    render_json t(".not_found"), 404 unless @job
  end

  def render_json message, status
    respond_to do |format|
      format.json{render json: {flash: message, status: status}}
    end
  end
end
