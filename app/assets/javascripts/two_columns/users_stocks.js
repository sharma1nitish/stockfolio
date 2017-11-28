$(function() {
  // setTimeout(function(){
    var $items = $('.user-stock-list li.user-stock-content:not(.user-stock-footer, .hidden)');

    $items.each(function(index) {
      var $item = $(this);

      $.ajax({
        type: 'POST',
        url: '/get_current_price?users_stock_id=' + $item.data('id') + '&bse_code=' + $item.find('.bse-code').html(),
      }).done(function (data) {
        refreshRealTimeData($item, data)
      }).fail(function () {
        jQuery.Deferred().fail.apply(this, arguments);
      });

      function refreshRealTimeData($item, data) {
        $item.find('.cp').html(data.current_price);
        $item.find('.total').html(data.users_stock_change_percentage);
        $item.find('.value').html(data.users_stock_value);
      }
    })
  // }, 15000);
})
