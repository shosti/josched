class UsersController < Clearance::UsersController
  before_filter :correct_user, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    new_password = params[:user][:password]
    if new_password
      @user.password = new_password
      if @user.save
        flash[:success] = 'Password changed'
      else
        flash[:error] = 'Error changing password'
      end
    end
    render 'edit'
  end

  def destroy
    @user = current_user
    sign_out
    @user.destroy
    redirect_to root_path
  end

  private

  def correct_user
    redirect_to root_path if params[:id].to_i != current_user.id
  end
end
