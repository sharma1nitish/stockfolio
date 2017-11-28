$(function() {
  var REFRESH_TIMEOUT = 60 * 1000;

  refresh()
  // setInterval(refresh(), REFRESH_TIMEOUT);

  function refresh() {
    var $headerItems = $('.card-header .stock[data-code="NIFTY"], .stock[data-code="SENSEX"]');
    var $items = $('.user-stock-list li.user-stock-content:not(.user-stock-footer, .hidden)');

    $headerItems.each(function(index) {
      var $item = $(this);

      $.ajax({
        type: 'GET',
        url: '/get_general_price?code=' + $item.data('code'),
      }).done(function (data) {
        refreshRealTimeData($item, data)
      }).fail(function () {
        jQuery.Deferred().fail.apply(this, arguments);
      });
    })

    $items.each(function(index) {
      var $item = $(this);

      $.ajax({
        type: 'POST',
        url: '/get_current_price?users_stock_id=' + $item.data('id') + '&bse_code=' + $item.find('.bse-code').html(),
      }).done(function (data) {
        refreshUsersStockData($item, data)
      }).fail(function () {
        jQuery.Deferred().fail.apply(this, arguments);
      });
    })

    function refreshRealTimeData($item, data) {
      $item.find('.amount').html(data.current_price);
      $item.find('.change .percentage').html(data.change_percentage);
      refreshCaret($item, data.change_percentage);
    }

    function refreshUsersStockData($item, data) {
      debugger
      var $portfolio = $('.stock.total')

      $item.find('.cp').html(data.current_price);
      $item.find('.total').html(data.change_percentage);
      $item.find('.value').html(data.users_stock_value);

      refreshCaret($item, data.change_percentage);

      $('.user-stock-footer .value').html(sumValues())
      $('.user-stock-footer .total').html(totalPercentageChange())

      $portfolio.find('.amount').html(sumValues());
      $portfolio.find('.change .percentage').html(totalPercentageChange());
      refreshCaret($item, totalPercentageChange());
    }
  }

  function refreshCaret($item, change_percentage) {
    if (parseFloat(change_percentage) < 0) {
      $item.find('.change-direction').addClass('down');
    } else {
      $item.find('.change-direction').addClass('up');
    }
  }

  function sumValues() {
    var sum = 0;

    $('li.user-stock-content:not(.hidden, .user-stock-footer) .value').each(function() {
      sum += parseFloat($(this).html())
    })

    return sum;
  }

  function totalPercentageChange() {
    var totalInvestment = $('.user-stock-footer .investment .amount').html();
    return ((parseFloat(totalInvestment) / sumValues()) - 1) * 100
  }
})

