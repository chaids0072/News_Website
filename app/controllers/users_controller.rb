# This file is created by gang chen and it is to be submitted to the university
# of melbourne as project 2 assignement
#
# I hereby declare that some of the codes are being used as 'erb'
# and I used Wordgram solution to implement this programme
# Wordgram is authored under the name of Mathew Blair
#
#
# Author::    Gang chen
# Copyright:: Gang chen
# pub_date::  19/09/2015

class UsersController < ApplicationController

  # Some before actions for some methods
  # it is importer to keep the logic consequence in sequential order in 
  # website designing
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :destroy, :update]
  before_action :check_valid, only: [:edit, :destroy, :update]


  # create a user
  def new
    @user = User.new
  end

  # Store the user that will have been created to database
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to articles_path,
        notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # A user can be updated in terms of their personal information
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to articles_path,
        notice: 'user was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # A user can be also destoried
  def destroy
    log_out
    @user.destroy
    respond_to do |format|
      format.html { redirect_to login_path,
      notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # To set up users
  def set_user
    @user = User.find(params[:id])
  end

  # To see if the current user is a valid user
  def check_valid
    unless @user==current_user
      redirect_to articles_path
    end
  end

  # Only allow certain types of symbols to bring protection to this software
  def user_params
    params.require(:user).permit(:first_name,
    :last_name, :email, :bio, :username, :password,
    :interest_list, :password_confirmation)
  end
end
