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

require 'rubygems'
require 'bundler/setup'
require 'sentimental'

require 'open_calais'

require 'alchemy_api'

require 'indico'

class Article < ActiveRecord::Base
	# Relationship
	belongs_to :provider

	# Articles can have tags
	acts_as_taggable

	# This is the method that is used to tag articles
	# Important words such as proper nouns must be imcluded
	# There are many ways to isolate those words out
	# the one I used may be similiar to those have already been posted
	# on Internet
	def self.tag_articles
		Article.all.each do |a|
			# strings2 = Array[]
			# strings2.push(tag_title(a.title))

			# strings2.join(',')
			# a.tag_list = strings2
			string1 = Array[]

			string1.push(tag_sentimental(a.summary))
			string1.push(tag_open_calais(a.title))
			string1.push(tag_alch(a.summary))
			string1.push(tag_indico(a.title))
			string1.push(tag_final(a.link))

			a.tag_list = string1.uniq.join(',')

			a.save
		end

		#((/(?:\s*\b([A-Z][a-z]+)\b)+/).match(item)).to_s
	end

	# Tagging method one
	def self.tag_sentimental summary
		Sentimental.load_defaults
		Sentimental.threshold = 0.1

		article1 = summary
		s = Sentimental.new

		s.get_sentiment article1
	end

	# Tagging method two
	def self.tag_open_calais title
		strings2 = Array[]

		article1 = title
		oc = OpenCalais::Client.new(api_key: "M790DGC3aG5NlBGJZFR2vy3YBPB5hP11")
		oc_response = oc.enrich article1

		#get the most relaven tag out of
		oc_response.tags.each do |t|
			if t[:score] >= 0.9
				strings2.push(t[:name].to_s)
			end
		end

		strings2.join(',')
	end

	# Tagging method three
	def self.tag_alch summary
		strings3 = Array[]
		article1 = summary
		AlchemyAPI.key = 'babad45ace2ccd70ed3638372f103f8728007cfe'

		a_entities = AlchemyAPI::EntityExtraction.new.search(text: article1)
		a_entities.each do |c|
			strings3.push(c['text'])
		end

		strings3.join(',')
	end

	# Tagging method four
	def self.tag_indico	title
		string4 = Array[]
		Indico.api_key = 'ed421277887ff0cb2f500296e63a42a1'
		article1 = title

		ind_keywords = Indico.keywords article1
		ind_keywords.each do |k, v|
			string4.push(k)
		end

		string4.join(',')
	end

	# Tagging method five
	def self.tag_final link
		if link != nil
			((/(?:\s*\b([A-Z][a-z]+)\b)+/).match(link)).to_s
		else
			''
		end
	end

	def self.search_target item
		#Tag.where(" title LIKE ? " , "%#{item}%")
		if item
			# adding weight to each article accordingly
			# tag has 4
			# title has 3
			# description has 2
			# link has 1
			Article.all.each do |a|
				# Clear weight for re-calculating the weight for each article
				a.weight = 0
				# a.save

				# Article rank method
				if string_match_one(a.tag_list.flatten,item) == 1
					a.weight += 4
				end

				if string_match_one(a.title,item) == 1
					a.weight += 3
				end

				if string_match_one(a.summary,item) == 1
					a.weight += 2
				end

				if string_match_one(a.link,item) == 1
					a.weight += 1
				end

				a.save
			end

			# Put them into a hash in order to sort articles by values
			articles_in_order_hash = Hash.new
			Article.all.each do |b|
				if b.weight != 0
					articles_in_order_hash.store(b,b.weight)
				end
			end

			# Sorting articles by weight
			# Also Sorting articles by publishdate if weights are the same for two articles
			Hash[articles_in_order_hash.sort]

			# Retrieve articles back to a new array
			artiles_in_order_array = Array.new

			articles_in_order_hash.each do |key, array|
				artiles_in_order_array.push(key)
			end

			# Clear the weight after using it for preparing the next searching
			Article.all.each do |c|
				c.weight = 0
				c.save
			end

			#return the array that has been sorted
			artiles_in_order_array
		else
			all
		end

	end

	# This method is for string match
	def self.string_match_one object_one,object_two
		if object_one.split.join.include? object_two
			1
		else
			0
		end
	end
end
