class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(10)
    respond_to do |format|
      format.html
    end
  end

  # <%= wicked_pdf_image_tag 'rails.png' %>

  def export
    @users = User.order(created_at: :desc)
    respond_to do |format|
      format.xlsx
      format.pdf do
        render pdf: 'users', layout:'pdf.html', template: 'users/export', footer: { right: '[page]'  },
               margin: { :top => 15, :bottom => 21, :left => 12, :right => 12 },
               orientation: 'Landscape', page_size: 'A4'
      end
    end
  end

  def import
    if params[:file].present?
      User.import_file params[:file]
      redirect_to root_url
      flash[:success] =  "Data imported"
    else
      redirect_to root_url
      flash[:error] =  "Data not imported"
    end
  end

  def download
    @users = User.all
    render pdf: 'users', layout:'pdf.html', template: 'users/export', footer: { right: '[page]'  },
           margin: { :top => 15, :bottom => 21, :left => 12, :right => 12 }, disposition: :attachment
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
