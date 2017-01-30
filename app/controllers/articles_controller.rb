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

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  # Include the importer modele in model layer 
  # so methods in model layer can be used
  include Importer

  # The initiator is used to set up importes
  def initiator

    # Sources are initialized through a method called
    # 'provided_importer'
    Importer::HeraldsunWorld.provided_importer
    Importer::TheNewYorkTime.provided_importer
    Importer::HeraldsunBusiness.provided_importer
    Importer::HeraldsunSport.provided_importer
    Importer::AgeTopStory.provided_importer
    Importer::SydneyMorningEntertainment.provided_importer
  end

  # Refresh the page
  def refresh
    # If no sources, or in other words, the first Provider was not
    # given then initialize them before implementation
    # Else, just scrape news from stored websites
    if Provider.all.first == nil
      initiator
    else
      # the total number of sources is 6
      # starting from 1 and we use counter to swich
      counter = 1;
      Provider.all.each do |source|
        case counter
        when 1
          Importer::HeraldsunWorld.scrape_rss(source)
          counter += 1
        when 2
          ############Importer::TheNewYorkTime.scrape_json(source)
          counter += 1
        when 3
          #Importer::HeraldsunBusiness.scrape_rss(source)
          counter += 1
        when 4
          #Importer::HeraldsunSport.scrape_rss(source)
          counter += 1
        when 5
          #Importer::AgeTopStory.scrape_rss(source)
          counter += 1
        when 6
          #Importer::SydneyMorningEntertainment.scrape_rss(source)
          counter += 1
        else
          #invaild address is not accepted
        end
      end

      Article.tag_articles

      # redirect to articles for user to continue reading
      redirect_to articles_path,notice: 'Refreshed'
    end
  end

  # the index page is to show all the articles that have been scraped down
  def index
    @articles = Article.search_target(params[:search])
  end

  def my_interests
      @articles = Article.tagged_with(current_user.interest_list,
      :any => true).to_a
      render 'index'
  end

  # Create an article
  def create
    @article = Article.new(article_params)
    @article.importer_source = @importer
    respond_to do |format|
      if @article.save
        format.html { redirect_to @Article,
        notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @Article }
      else
        format.html { render :new }
        format.json { render json: @Article.errors,
        status: :unprocessable_entity }
      end
    end
  end

  # Detroy and article
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path,
      notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # To set up article
  def set_article
    @article = Article.find(params[:id])
  end

  # Enter parameters that are accepted
  # this can filter the others out
  def Article_params
    params.require(:article).permit(:image,:link,:title,
    :pubDate, :tag_list, :importer_source_id,:summary)
  end
end