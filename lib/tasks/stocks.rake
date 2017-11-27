namespace :stocks do
  desc 'Populate stocks'
  task refresh: :environment do
    # Stock.find_each { |stock| stock.update_attribute!(:last_buying_price, StockQuote::Stock.quote(stock.code).l) }

    # puts "Reloaded stock table with #{Stock.count} records"
  end

  desc 'Refresh last buying price of stocks'
  task refresh: :environment do
    Stock.find_each { |stock| stock.update_attribute!(:last_buying_price, StockQuote::Stock.quote(stock.code).l) }

    puts "Reloaded stock table with #{Stock.count} records"
  end
end
