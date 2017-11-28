$(function() {
  var REFRESH_TIMEOUT = 500;

  refresh();
  // setInterval(refresh, REFRESH_TIMEOUT);

  function refresh() {
    var $headerItems = $('.card-header .stock[data-code="NIFTY"], .stock[data-code="SENSEX"]');
    var $items = $('.user-stock-list li.user-stock-content:not(.user-stock-footer, .hidden)');

    var headerItemsPromises = $.map($headerItems, function(item) {
      return $.ajax({
        type: 'GET',
        url: '/get_general_price?code=' + $(item).data('code'),
      })
    })

    var itemsPromises = $.map($items, function(item) {
      return $.ajax({
        type: 'POST',
        url: '/get_current_price?users_stock_id=' + $(item).data('id') + '&bse_code=' + $(item).find('.bse-code').html(),
      })
    })

    $.when.apply($, headerItemsPromises)
      .then(function() {
        $.each(arguments, function(index, value) {
          refreshRealTimeData($($headerItems[index]), value[0])
        });
      })
      .fail(function() {
        console.log('Failed to refreshRealTimeData')
      });

    $.when.apply($, itemsPromises)
      .then(function() {
        var currentTotalValue = sumValues(arguments)
        $.each(arguments, function(index, value) {
          refreshUsersStockData($($items[index]), value[0], currentTotalValue)
        });
      })
      .fail(function() {
        console.log('Failed to refreshUsersStockData')
      });

    console.log('Refreshed')
  }

  function refreshRealTimeData($item, data) {
    $item.find('.amount').html(data.current_price);
    $item.find('.change .percentage').html(data.change_percentage);
    refreshCaret($item, data.change_percentage);
  }

  function refreshUsersStockData($item, data, currentTotalValue) {
    var $portfolio = $('.stock.total')

    $item.find('.cp').html(data.current_price);
    $item.find('.total').html(data.change_percentage);
    $item.find('.value').html(data.users_stock_value);

    refreshCaret($item, data.change_percentage);

    $('.user-stock-footer .value').html(currentTotalValue)
    $('.user-stock-footer .total').html(totalPercentageChange(currentTotalValue))

    $portfolio.find('.amount').html(currentTotalValue);
    $portfolio.find('.change .percentage').html(totalPercentageChange(currentTotalValue));

    refreshCaret($portfolio, totalPercentageChange(currentTotalValue));
  }

  function refreshCaret($item, change_percentage) {
    if (parseFloat(change_percentage) < 0) {
      $item.find('.change-direction').addClass('down');
    } else {
      $item.find('.change-direction').addClass('up');
    }
  }

  function sumValues(arguments) {
    var sum = 0;

    $.each(arguments, function(index, value) {
      sum += value[0].users_stock_value
    });

    return sum;
  }

  function totalPercentageChange(currentTotalValue) {
    var totalInvestment = $('.user-stock-footer .investment .amount').html();
    return ((currentTotalValue / (parseFloat(totalInvestment)) - 1) * 100).toFixed(1)
  }
})

