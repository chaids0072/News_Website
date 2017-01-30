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
require 'rss'
require 'open-uri'
require 'net/http'

class Importer::HeraldsunWorld

	# This method is to initialize the source in terms of
	# Source.name
	# Source.type
	# url address
	# for scraping articles later on
	def self.provided_importer
		#Source_Four
		Provider.create(source_name: 'Heraldsun_world_news',source_type: 'rss',
		url: 'http://feeds.news.com.au/heraldsun/rss/'\
		'heraldsun_news_worldnews_2793.xml')
	end

	# Articles are created here in the model layer throuhg this method
	def self.scrape_rss source_rss
		open(source_rss.url) do |rss|
			feed = RSS::Parser.parse(rss)
			feed.items.each do |item|

				# Avoid repeated Articles by checking the title of Articles
				current_title = Article.find_by(title: item.title)

				# The information below is to as instructed to be stored
				# for each one of the articles
				if !current_title
					#tag = Article.tag_article(item.description)
					Article.create(
					provider_id: source_rss.id,
					title:(item.respond_to? :title) ? item.title : nil,
					pubDate:(item.respond_to? :pubDate) ? item.pubDate : nil,
					summary:(item.respond_to? :description) ? item.description : nil,
					author:(item.source.respond_to? :author) ? item.source.author : nil,
					image:(item.enclosure.respond_to? :url) ? item.enclosure.url : nil,
					link:(item.respond_to? :link) ? item.link : nil,
					tag_list: nil, weight: '0'.to_i)
				end
			end
		end
	end
end