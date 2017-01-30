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

class ApplicationController < ActionController::Base
  # Protection
  # generated automatically
  protect_from_forgery with: :exception

  # Including a session helper
  include SessionsHelper

  # To include this method for session purpose
  def authenticate_user
    if !current_user
      render :file => File.join(Rails.root, 'public', '401.html'),:status => 401
    end
  end
end
