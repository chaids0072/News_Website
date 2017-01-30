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

class Provider < ActiveRecord::Base
	has_many :article
end
