#!/usr/bin/env ruby
# encoding: utf-8

require 'data_mapper'
require 'json'
require 'sinatra'
require 'pony'

require './models.rb'

if ENV['SENDGRID_USERNAME']
  set :static_cache_control, [:public, {:max_age => 300}]
  Pony.options = {
      :via => :smtp,
      :via_options => {
          :host => 'smtp.sendgrid.net',
          :port =>587,
          :user_name => ENV['SENDGRID_USERNAME'],
          :password => ENV['SENDGRID_PASSWORD'],
          :authentication => :plain,
          :domain => 'heroku.com',
        }
  }
else
  Pony.options = {
      :via => :smtp,
      :via_options => {
          :host => 'localhost',
          :port => 1025,
          :authentication => :plain,
          :domain => 'heroku.com',
        }
  }
end

@pct = Pct.new(name: "FristPCT")
@pct.save
@ccg = Ccg.new(name: "FristCCG")
@ccg.save
@surg = Practice.new(name: "Frist Surg",
                     address: "1 Acacia Ave",
                     postcode: "GG2 4GS",
                     email: "this@that.com",
                     ccg: @ccg,
                     pct: @pct
                     )
@surg.save

get '/' do
  @title = 'Chat to a doctor'
  @pract =  Practice.get(1)
  haml :index
end

get '/practices/:slug' do
  @pract = Practice.first(slug: params[:slug])
  @title = @pract.name
  haml :practice
end

get '/ccg/:slug' do
  @ccg = Ccg.first(slug: params[:slug])
  @title = Ccg.name
  haml :ccg
end

get '/pct/:slug' do
  @pct = Pct.first(slug: params[:slug])
#  require 'ruby-debug'; debugger
  @title = Pct.name
  haml :pct
end
