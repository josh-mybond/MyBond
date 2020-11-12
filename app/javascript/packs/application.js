// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("@fortawesome/fontawesome-free");

// sockets
require('channels/admin');

// charts
require("chartkick");
require("chart.js");

// datepicker - https://flatpickr.js.org/
import flatpickr from "flatpickr"
// import "flatpickr/dist/flatpickr.min.css"

document.addEventListener('DOMContentLoaded', function() {

  let today   = new Date();
  let year    = today.getFullYear();
  // var month   = today.getMonth();
  // var day     = today.getDate();
  var dob_maxDate = new Date(year - 15, 1, 1);

  // allow start from one month ago..
  let lease_min_date = new Date();
  let lease_end_date = new Date();
  lease_min_date.setMonth(lease_min_date.getMonth() - 1);
  lease_end_date.setMonth(lease_min_date.getMonth() + 12);

  flatpickr(".date_of_birth_picker", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    minDate: "1900-01",
    maxDate: dob_maxDate
  });

  flatpickr(".contract_start_date_picker", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    minDate: lease_min_date,
    defaultDate: today
  });

  flatpickr(".contract_end_date_picker", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    minDate: lease_min_date,
    defaultDate: lease_end_date
  });




})


import '../stylesheets/application';
import "bootstrap";

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import './address_validation';
//import './mutation_observer';
import './stripe';
// import './split_payments';
