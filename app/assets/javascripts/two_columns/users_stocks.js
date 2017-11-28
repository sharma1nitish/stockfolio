$(function() {
  var REFRESH_TIMEOUT = 5000;

  refresh();
  setInterval(refresh, REFRESH_TIMEOUT);

  function refresh() {
    var $headerItems = $('.card-header .stock[data-code="NIFTY"], .stock[data-code="SENSEX"]');
    var $items = $('.user-stock-list li.user-stock-content:not(.user-stock-footer, .hidden)');

    var headerItemsPromises = $.map($headerItems, function(item) {
      return $.ajax({
        type: 'GET',
        url: '/get_general_price?code=' + $(item).data('code'),
      });
    })

    $.when.apply($, headerItemsPromises)
      .then(function() {
        $.each(arguments, function(index, value) {
          refreshRealTimeData($($headerItems[index]), value[0]);
        });
      })
      .fail(function() {
        console.log('Failed to refreshRealTimeData');
      });

    if ($items.length) {
      var itemsPromises = $.map($items, function(item) {
        return $.ajax({
          type: 'POST',
          url: '/get_current_price?users_stock_id=' + $(item).data('id') + '&bse_code=' + $(item).find('.bse-code').html(),
        });
      })

      $.when.apply($, itemsPromises)
        .then(function() {
          if ($.isArray(arguments[0])) {
            var currentTotalValue = sumValues(arguments)

            $.each(arguments, function(index, value) {
              refreshUsersStockData($($items[index]), value[0], currentTotalValue);
            });
          } else {
            refreshUsersStockData($($items), arguments[0], arguments[0].users_stock_value);
          }
        })
        .fail(function() {
          console.log('Failed to refreshUsersStockData');
        });
    }


    console.log('Refreshed');
  }

  function refreshRealTimeData($item, data) {
    $item.find('.amount').html(formatNumber(data.current_price));
    $item.find('.change .percentage').html(data.change_percentage);
    refreshCaret($item, data.change_percentage);
  }

  function refreshUsersStockData($item, data, currentTotalValue) {
    var $portfolio = $('.stock.total');
    var $footer = $('.user-stock-footer');
    var formattedCurrentTotalValue = formatNumber(currentTotalValue);
    var percentageChange = totalPercentageChange(currentTotalValue);

    $item.find('.cp').html(formatNumber(data.current_price));
    $item.find('.total .amount').html(formatNumber(data.change_percentage));
    $item.find('.value').html(formatNumber(data.users_stock_value));

    refreshCaret($item, data.change_percentage);

    $footer.find('.value').html(formattedCurrentTotalValue);
    $footer.find('.total .amount').html(percentageChange);

    refreshCaret($footer, percentageChange);

    $portfolio.find('.amount').html(formattedCurrentTotalValue);
    $portfolio.find('.change .percentage').html(percentageChange);

    refreshCaret($portfolio, percentageChange);
  }

  function refreshCaret($item, change_percentage) {
    if (parseFloat(change_percentage) < 0) {
      $item.find('.change-direction').addClass('down');
    } else {
      $item.find('.change-direction').addClass('up');
    }
  }

  function sumValues(arguments) {
    if (!$.isArray(arguments[0])) return arguments[0].users_stock_value;

    var sum = 0;

    $.each(arguments, function(index, value) {
      sum += value[0].users_stock_value;
    });

    return sum;
  }

  function totalPercentageChange(currentTotalValue) {
    var totalInvestment = $('.user-stock-footer .investment .amount').html().replace(/,/g, '');
    return (((currentTotalValue / parseFloat(totalInvestment)) - 1) * 100).toFixed(1);
  }

  function formatNumber(number) {
    if (number.toString().indexOf(',') > -1) return number;

    return Number(number).toLocaleString('en');
  }
})

