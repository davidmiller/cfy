# Migrate the base data in
require 'csv'
require 'data_mapper'
require './models.rb'

DataMapper.finalize.auto_migrate!

csv_text = File.read(File.dirname(__FILE__) + '/../data/practice_emails.csv')
csv = CSV.parse(csv_text, headers: true, header_converters: :symbol)
count = 1
csv.each do |r|
  r = r.to_hash
  count += 1
  if count > 10
      break
  end
  puts "-------------"
  puts r
  @pct = Pct.first_or_create(name: r[:pct])
  puts @pct.name


  @practice = Practice.new(
                           name:     r[:name],
                           address:  r[:addr],
                           postcode: r[:postcode],
                           email:    r[:email],
                           pct:      @pct
                           )
  @practice.save
  @pct.practices << @practice
  @pct.save

  puts @practice.pct
  puts @pct.practices.all
  puts @practice.pct.practices
end
