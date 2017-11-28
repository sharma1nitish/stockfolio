require 'open-uri'

erroneous_codes_count = 0

csv_text = File.read('./lib/list_of_scrips.csv')
csv = CSV.parse(csv_text, headers: true)

csv.to_a[1..10].each do |data|
  begin
    last_buying_price = BigDecimal(StockQuote::Stock.quote("BOM:#{data[0]}").l)
    stock_attributes = { bse_code: data[0], name: data[2], symbol: data[1] }
    stock = Stock.where(stock_attributes).first_or_initialize
    stock.last_buying_price = last_buying_price
    stock.save!
  rescue Exception => e
    erroneous_codes_count += 1
    next
  end
end

puts "Populated #{Stock.count} stocks records. Could not retrieve data for #{erroneous_codes_count} companies"
