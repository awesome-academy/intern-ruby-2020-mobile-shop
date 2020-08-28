class Admins::UsersController < AdminsController
  before_action :find_user, only: %i(show edit update destroy)

  def index
    @search = User.ransack(params[:q])
    @users = @search.result
                    .page(params[:page])
                    .per(Settings.per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".user_created_success"
      redirect_to admins_users_path
    else
      flash[:danger] = t ".user_create_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".user_updated"
      redirect_to [:admins, @user]
    else
      flash[:danger] = t ".user_update_fail"
      render :edit
    end
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to admins_users_path
    else
      flash[:danger] = t ".user_delete_fail"
      redirect_to root_path
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".unknown_user"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::PERMIT_CREATE_ATTRIBUTES
  end
end
