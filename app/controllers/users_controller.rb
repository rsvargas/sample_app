class UsersController < ApplicationController
  before_filter :non_signed_in_user,  only: [:new, :create]
  before_filter :signed_in_user,      only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,        only: [:edit, :update]
  before_filter :admin_user,          only: :destroy
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] =  "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id]) # agora o before_filter correct_user já faz isto
  end
  
  def update
    # @user = User.find(params[:id]) # agora o before_filter correct_user já faz isto
    if @user.update_attributes( params[:user] )
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = 'Cannot delete itself'
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = 'User deleted'
      redirect_to users_url
    end
  end
  
  private
    def non_signed_in_user
      redirect_to root_path if signed_in?  
    end
        
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
