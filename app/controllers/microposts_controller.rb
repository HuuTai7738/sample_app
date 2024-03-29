class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "post_created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed,
                                item: Settings.microposts_per_pag
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "post_deleted"
    else
      flash[:danger] = t"post_deleted_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost_invalid"
    redirect_to request.referer || root_url
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
