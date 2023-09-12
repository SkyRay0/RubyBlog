class UserController < ApplicationController
  def edit
    @user = User.find_by id: params[:id]
    if @user.id == current_user.id
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find_by id: params[:id]
    @articles = Article.where user_id: @user.id
  end

  def update
    if @current_user.update user_params
      redirect_to "/user/#{(User.find_by id: current_user.id).id}"
    else
      render :edit
    end
  end

  def like
    if !@current_user.favourite_users.nil? && @current_user.favourite_users.include?(params[:id].to_str)
      @current_user.favourite_users = @current_user.favourite_users.chomp(params[:id].to_str + ",")
    elsif @current_user.favourite_users.nil?
      @current_user.favourite_users = params[:id].to_str + ","
    else
      @current_user.favourite_users += params[:id].to_str + ","
    end
    @current_user.save
    redirect_to user_path
  end

  private


  def user_params
    params.require(:user).permit(:description, :avatar, :username)
  end
end