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

module SessionsHelper

	# Store the session for user
	# so that the same user does not have to keep logging in
	# even the connection failed the user in a short period of time
	def log_in user
		session[:user_id] = user.id
	end

	# To return the current user whenever this method is called
	def current_user
		if !@current_user
			@current_user =  User.find_by(id: session[:user_id])
		end
		@current_user
	end

	# Log out the user
	# in other words
	# the session is then discarded
	def log_out
		session[:user_id] = nil
	end
end

