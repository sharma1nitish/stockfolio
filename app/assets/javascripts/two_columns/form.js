$(function() {
  var $form = $('form')

  $form.on('submit', function (event) {
    $form.parents('.modal').modal('hide');

    event.preventDefault();

    $.ajax({
      type: 'POST',
      url: $form.data('url'),
      data: $form.serialize()
    }).done(function (data) {
      $form[0].reset();

      if (data.status == 'created') {
        addNewUsersStock(data);
      } else if (data.status == 'updated') {
        var $item = $('#user-stocks li[data-id="' + data.user_stock_id + '"]');

        if (parseInt(data.quantity) == 0) $item.remove();

        refreshUsersStockData($item, data)
      }

      updateTotals(data);

      jQuery.Deferred().done.apply(this, arguments);
    }).fail(function () {
      jQuery.Deferred().fail.apply(this, arguments);
    });
  });

  $('#transaction_stock_id').select2({
    width: '100%',
    minimumInputLength: 3,
    ajax: {
      url: '/get_stocks',
      dataType: 'json',
      type: 'GET',
      quietMillis: 50,
      data: function (symbol) {
        return { term: symbol };
      },
      processResults: function (data) {
        return {
          results: $.map(data.stocks, function (item) {
            return {
              text: item.symbol,
              slug: item.bse_code,
              id: item.id
            }
          })
        }
      }
    }
  });

  function refreshUsersStockData($item, data) {
    $item.find('.investment .amount').html(data.investment);
    $item.find('.investment .percentage').html(data.investment_percentage);
    $item.find('.nos').html(data.quantity);
    $item.find('.lbp').html(data.last_buying_price);
    $item.find('.abp').html(data.average_buying_price);
  }

  function addNewUsersStock(data) {
    var $lastChild = $('#user-stocks li:last-child');
    var $item = $lastChild.clone();
    var $lastItem = $('li.last');

    $item.attr('data-id', data.user_stock_id);
    $item.find('.company').html(data.name);
    $item.find('.bse-code').html(data.bse_code);

    refreshUsersStockData($item, data);

    if ($lastItem.length) {
      $item.insertAfter($lastItem);
      $lastItem.removeClass('last');
    } else {
      $item.prependTo($lastChild.parent());
    }

    $item.addClass('last');
    $item.removeClass('hidden');
  }

  function updateTotals(data) {
    var $header = $('.user-stock-header');
    var $footer = $('.user-stock-footer');

    $header.find('.companies .count').html(data.company_count);
    $footer.find('.investment .amount').html(data.total_investment);
    $footer.find('.investment .percentage').html(data.investment_percentage);
    $footer.find('.nos').html(data.total_quantity);
    $footer.find('.lbp').html(data.avg_lbp);
    $footer.find('.abp').html(data.avg_abp);
  }
})
