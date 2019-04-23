// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require rails-ujs
//= require activestorage
// require jquery/dist/jquery
// require bootstrap/js/bootstrap.bundle.min
// require datatables/jquery.dataTables
// require datatables/media/js/dataTables.bootstrap.min
// require select2.min
// require_tree .
//= require_tree ./angle/

$(function() {
  var dataTable = null;
  document.addEventListener("turbolinks:before-cache", function() {
    if (dataTable !== null) {
      dataTable.destroy();
      dataTable = null;
    }
  });
});

//= require turbolinks