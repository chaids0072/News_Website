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

require 'Date'
require 'open-uri'

require 'json'
require 'net/http'

class Importer::TheNewYorkTime

	# This method is to initialize the source in terms of
	# Source.name
	# Source.type
	# url address
	# for scraping articles later on
	def self.provided_importer
		#Source_six
		Provider.create(source_name: 'The New York Times',source_type: 'json',
		url: 'http://api.nytimes.com/svc/news/v3/'\
		'content/all/Health/.json?api-key=sample-key')

	end

	# Articles are created here in the model layer throuhg this method
	def self.scrape_json source_json

		# Try to get information from a given url link
		forecast = JSON.parse(open(URI.parse(source_json.url)).read)
		forecast['results'].each do |item|
			tag = Article.tag_article(item['snippet'])

			# Avoid repeated Articles by checking the title/date of Articles
			current_title = Article.find_by(title: item['title'])
			if !current_title

				# The information below is to as instructed to be stored
				# for each one of the articles
				Article.create!(
				provider_id: source_json.id,
				author: item['byline'],
				title: item['title'],
				summary: item['abstract'],
				image: item['thumbnail_standard'],
				pubDate: DateTime.parse(item['published_date']),
				link:item['url'],
				tag_list: tag
				)
			end
		end
	end
end



