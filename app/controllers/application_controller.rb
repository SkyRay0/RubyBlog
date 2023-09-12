class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :get_current_user_desc

  private

  def get_current_user_desc
    if user_signed_in?
      @current_user = User.find_by id: current_user.id
    end
  end

  def not_found
    render file: "public/404.html", status: :not_found, layout: false
  end
end
