namespace :stocks do
  desc 'Refresh last buying price of stocks'
  task refresh: :environment do
    Stock.refresh_prices_of_all!

    puts "Reloaded stock table with #{Stock.count} records"
  end
end
