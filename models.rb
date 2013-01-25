require 'data_mapper'

module Urlify
  module InstanceMethods
    def url
      '/practices/' + @slug
    end
  end
end

DataMapper::Model.append_inclusions(Urlify::InstanceMethods)

class Pct
  include DataMapper::Resource

  has n, :practices

  property :id, Serial
  property :name, String
  property :slug, String, default: lambda { | r, p | r.name.downcase.sub " ", "-"}
end

class Ccg
  include DataMapper::Resource

  has n, :practices

  property :id, Serial
  property :name, String
  property :slug, String, default: lambda { | r, p | r.name.downcase.sub " ", "-"}
end

class Practice
  include DataMapper::Resource

  belongs_to :pct
  belongs_to :ccg, required: false

  property :id, Serial
  property :name, String
  property :address, Text
  property :postcode, String
  property :email, String
  property :slug, String, default: lambda { | r, p | r.name.downcase.sub " ", "-"}
end


DataMapper.setup(:default, "sqlite3:///tmp/cfy.db")
DataMapper.finalize.auto_upgrade!

Practice.raise_on_save_failure = true
Pct.raise_on_save_failure = true
Ccg.raise_on_save_failure = true
