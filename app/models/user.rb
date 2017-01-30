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

class User < ActiveRecord::Base
	# Validations
	# This is to be used when verify valid data
	# Limitations are brought to users when it comes down to user account.
	validates_presence_of :email, :first_name, :last_name, :username

	# Valid email using regex
	validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/,
	message: "%{value} is not a valid email" }

	# The minimum username length is set to 1
	validates :username, length: { minimum: 1 }

	# Users can have interests
	acts_as_taggable_on :interests

	# Use secure passwords
	has_secure_password

	# Find a user by email, then check the username is the same
	def self.authenticate password, email
		user = User.find_by(email: email)
		if user && user.authenticate(password)
			return user
		else
			return nil
		end
	end

	# To return the full name of user
	def full_name
		first_name + ' ' + last_name
	end
end
