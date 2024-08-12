// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

window.Rails = require("@rails/ujs")
require("@hotwired/turbo-rails")
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")
require("local-time").start()
require("jquery")
// Start Rails UJS
Rails.start()

// Stimulus
import "controllers"

// Bootstrap
import 'bootstrap'
import 'bootstrap-datepicker'
import 'select2'
import "chartkick/chart.js"

// Add daterangepicker CSS
import 'daterangepicker/daterangepicker.css'

$.fn.datepicker.defaults.format = "dd-mm-yyyy";

document.addEventListener("turbo:load", () => {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  $('[data-toggle=datepicker]').datepicker();
  $('[data-toggle=select2]').select2();
  $('[data-toggle=tags_select2]').select2({
    placeholder: '',
    minimumInputLength: 1,
    tags: true,
    tokenSeparators: [',', ' '],
    width: '100%'
  });
})
