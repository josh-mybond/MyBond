
document.addEventListener("DOMContentLoaded", () => {

  let address = document.getElementById("contract_property_address");
  if (!address) { return }

  //
  // Form functions
  //

  function setCountry(country) {
    let element = document.getElementById("contract_property_iso_country_code");
    if (element) { element.value = country; }
  }

  function setPostCode(postCode) {
    let element = document.getElementById("contract_property_postcode");
    if (element) { element.value = postCode; }
  }

  const setupMaps = function() {

    var options = {
      types: ["geocode"],
      componentRestrictions: { country: "au" },
    };

    var autocomplete = new google.maps.places.Autocomplete(address, options);
    autocomplete.setFields(["address_components"]);
    autocomplete.addListener("place_changed", function() {

      var place = autocomplete.getPlace();

      // console.log(place);

      if (place.address_components) {
        for (const [key, value] of Object.entries(place.address_components)) {

          if (value["types"] && value["types"].length > 0) {

            // set form values from google maps
            if (value["types"][0] == "country")     { setCountry(value["short_name"]); }
            if (value["types"][0] == "postal_code") { setPostCode(value["short_name"]); }
          }
        }
      }
    });
  }

  window.setupMaps = setupMaps;

  // const googleApiKey = "AIzaSyBwm6YDqClkyb0eQz8fTVh7dZAz8PbHLGI";
  // TODO: replace with production one..
  const googleApiKey = "AIzaSyDHPVjNgG79rqU6e6_5nzbOwISVbTEAJig";
  var s = document.createElement("script");
  s.type = "text/javascript";
  s.src =
    "https://maps.googleapis.com/maps/api/js?key=" +
    googleApiKey + "&libraries=places&callback=setupMaps";
  document.body.appendChild(s);
});
