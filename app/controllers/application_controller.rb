class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :rack_mini_profiler_authorize_request, :set_locale,
    :shared_jobs, :shared_posts
  after_action :store_location

  include ApplicationHelper
  include PublicActivity::StoreController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  private

  def rack_mini_profiler_authorize_request
    environments = Rails.application.config.rack_mini_profiler_environments
    return unless Rails.env.in? environments
    Rack::MiniProfiler.authorize_request
  end

  def set_locale
    save_session_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def save_session_locale
    session[:locale] = params[:locale] if params[:locale]
  end

  def store_location
    unless request.path == "/users/sign_in" ||
      request.path == "/users/sign_out" ||
      request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for _resourse
    if cookies.signed[:tms_user].nil?
      authenticate_tms
      cookies.signed[:tms_user] = Api::TmsDataService.new(current_user,
        cookies.signed[:authen_service]).tms_user_exist?
    end
    session[:previous_url] || root_path
  end

  def shared_jobs
    @shared_job_ids = current_user.shares.pluck :shareable_id if user_signed_in?
  end

  def render_js message, status
    @render = Supports::UserWorkRender.new message, status
    respond_to do |format|
      format.js
    end
  end

  def convert_string_to_date param
    param.to_date
  rescue
    nil
  end

  def authenticate_tms
    if cookies.signed[:authen_service]
      @user_token = cookies.signed[:authen_service]
    else
      authen_service = Api::AuthenticateService.new(ENV["TMS_ADMIN_EMAIL"],
        ENV["TMS_ADMIN_PASSWORD"]).tms_authenticate
      if authen_service
        @user_token = authen_service["authen_token"]
        cookies.signed[:authen_service] = @user_token
      end
    end
  end

  def shared_posts
    if user_signed_in?
      @shared_post_ids = current_user.share_posts.pluck :shareable_id
    end
  end
end
