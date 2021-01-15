//
// document.addEventListener("DOMContentLoaded", () => {
//   let address = document.getElementById("address");
//   if (!address) { return }
//
//   const setupMaps = function() {
//
//     var options = {
//       types: ["geocode"],
//       componentRestrictions: { country: "au" },
//     };
//
//     var autocomplete = new google.maps.places.Autocomplete(address, options);
//     autocomplete.setFields(["address_components"]);
//     autocomplete.addListener("place_changed", function() {
//
//       let prefix = "";
//       if (document.getElementById('customer_previous_address_address1')) {
//         prefix = "customer_previous_address";
//       } else if (document.getElementById('property_address_address1')) {
//         prefix = "property_address";
//       }
//
//       function setValue(id, value) {
//         let element = document.getElementById(id);
//         if (element) { element.value = value["short_name"] }
//       }
//
//       var place = autocomplete.getPlace();
//
//       if (place.address_components) {
//         let premise       = "";
//         let street_number = "";
//         let route         = "";
//
//         for (const [key, value] of Object.entries(place.address_components)) {
//           if (value["types"] && value["types"].length > 0) {
//             // set form values from google maps
//             if (value["types"][0] == "premise")       { premise       = value["short_name"]; }
//             if (value["types"][0] == "street_number") { street_number = value["short_name"]; }
//             if (value["types"][0] == "route")         { route         = value["short_name"]; }
//             if (value["types"][0] == "locality")      { setValue(`${prefix}_address2`, value); }
//
//             if (value["types"][0] == "administrative_area_level_1") { setValue(`${prefix}_state`, value); }
//             if (value["types"][0] == "administrative_area_level_2") { setValue(`${prefix}_city`,  value); }
//             if (value["types"][0] == "country_code")  { setValue(`${prefix}_country_code`, value); }
//             if (value["types"][0] == "postal_code")   { setValue(`${prefix}_post_code`,    value); }
//           }
//         }
//
//         // Set address1
//         let address1       = "";
//         if (premise       != "") { address1 = `${premise} `; }
//         if (street_number != "") { address1 = `${address1}${street_number} `; }
//         if (route         != "") { address1 = `${address1}${route}`; }
//         setValue('customer_address1', { short_name: address1 });
//       }
//     });
//   }
//
//   window.setupMaps = setupMaps;
//
//   // const googleApiKey = "AIzaSyBwm6YDqClkyb0eQz8fTVh7dZAz8PbHLGI";
//   // TODO: replace with production one..
//   const googleApiKey = "AIzaSyDHPVjNgG79rqU6e6_5nzbOwISVbTEAJig";
//   var s = document.createElement("script");
//   s.type = "text/javascript";
//   s.src =
//     "https://maps.googleapis.com/maps/api/js?key=" +
//     googleApiKey + "&libraries=places&callback=setupMaps";
//   document.body.appendChild(s);
// });
