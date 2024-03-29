class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create destroy)

  def index
    @pagy, @user = pagy User.all.order_by_name, item: Settings.users_per_page
  end

  def show
    @pagy, @microposts = pagy @user.feed, item: Settings.microposts_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email"
      redirect_to root_url
    else
      flash[:danger] = t "create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if User.find_by(id: params[:id]).destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "user_deleted_fail"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.users_per_page
    render "show_follow"
  end

  def followers
    @title = t "followers"
    @pagy, @users = pagy @user.followers, items: Settings.users_per_page
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "just_admin"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end
end
