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

class SessionsController < ApplicationController

  # specify checking machanisim for some methods
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]


  # Only can login with a valid user account
  def login
    # Find a user with password/email
    user = User.authenticate(@credentials[:password], @credentials[:email])
    if user
      # Save the session
      log_in user
      # Redirect to articles page
      redirect_to articles_path
    else
      # If authorization failed, then displaya error message as (403)
      render :file => File.join(Rails.root, 'public', '403.html'),:status => 403
    end
  end

  # finish the session and then return user to login page
  def logout
    log_out
    redirect_to login_path
  end

  # Only Password/email are allowed in verifying users
  # a private method is then introduced
  private
  def check_params
    params.require(:credentials).permit(:password, :email)
    @credentials = params[:credentials]
  end

end
