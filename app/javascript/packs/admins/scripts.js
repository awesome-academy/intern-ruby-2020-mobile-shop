/*!
    * Start Bootstrap - SB Admin v6.0.1 (https://startbootstrap.com/templates/sb-admin)
    * Copyright 2013-2020 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-sb-admin/blob/master/LICENSE)
    */
(function ($) {
  "use strict";

  // Add active state to sidbar nav links
  var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
  $("#layoutSidenav_nav .sb-sidenav a.nav-link").each(function () {
    if (this.href === path) {
      $(this).addClass("active");
    }
  });

  // Toggle the side navigation
  $("#sidebarToggle").on("click", function (e) {
    e.preventDefault();
    $("body").toggleClass("sb-sidenav-toggled");
  });
})(jQuery);

$(document).ready(function() {
  $("#alert-message").fadeTo(5000, 500).slideUp(500, function(){
    $("#alert-message").slideUp(500);
  });
  $('#select-product').select2({
    placeholder: 'Select an option',
    allowClear: true,
    width: 500,
    tags: true
  });

  setAmount = function(price, product_id){
    let quantity = $('#product-id-' + product_id + ' input').val();
    $('#amount-' + product_id).text(quantity * price);
  };

  $('#select-product').on('change', function() {
    let ids = $("#select-product").val();
    $.ajax({
      url: '/admins/products/get_products_active',
      type: 'POST',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      data: {
        ids: ids
      },
      success: function (data) {
        $('#list-product').html("");
        $.each(data.products, function(i, item) {
          $('#list-product').append(
            '<input name="order[order_items_attributes][' + i + '][product_id]" type="hidden" value="' + item.id + '">' +
            '<input name="order[order_items_attributes][0][_destroy]" type="hidden" value="false">' +
            '<dt class="col-sm-4">' + item.name + '</dt>\n' +
            '<dd class="col-sm-4" id="product-id-' + item.id + '">' + '<div class="def-number-input number-input safari_only">\n' +
            '  <button type="button" class="dec" onclick="this.parentNode.querySelector(\'input[type=number]\').stepDown(); setAmount(' + item.price + ',' + item.id + ');" class="minus"></button>\n' +
            '  <input class="quantity" min="0" name="order[order_items_attributes][' + i + '][quantity]" value="1" type="number">\n' +
            '  <button type="button" class="inc" onclick="this.parentNode.querySelector(\'input[type=number]\').stepUp(); setAmount(' + item.price + ',' + item.id + ');" class="plus"></button>\n' +
            '</div>' + '</dd>\n' +
            '<dd class="col-sm-4" id="amount-' + item.id + '">' + item.price + '</dd>'
          );
        });
      },
      error: function (e) {
      }
    });
  })
});
