require 'sinatra/activerecord'
require 'pg'

configure :development do
  set :database, 'postgresql:migrationrumblr'
end

configure :production do
  # this environment variable is auto generated/set by heroku
  #   check Settings > Reveal Config Vars on your heroku app admin panel
  set :database, ENV["DATABASE_URL"]
end

class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :hashtags, :dependent => :destroy
end

class Hashtag < ActiveRecord::Base
  belongs_to :post
end