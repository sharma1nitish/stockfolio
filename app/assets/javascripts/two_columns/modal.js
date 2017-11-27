$(function(){
  $('.modal').appendTo('body');

  $('[data-modal="#add-transaction-modal"]').on('click', function(e) {
    $($(this).data('modal')).modal();
    e.stopPropagation(); // To stop the triggering of click event on the Portfolio tab
  });
})
