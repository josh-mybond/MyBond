import Includes from './includes';

document.addEventListener("DOMContentLoaded", () => {

  if (document.getElementById('mybond_calculator')) {
    const includes = new Includes();

    let url = document.getElementById('calculator_host');
    if (!url) { return }
    url = url.innerHTML;

    let error = false;

    let alert                    = document.getElementById('calculator_alert');
    let alert_content            = document.getElementById('calculator_alert_content');

    let calculator_rental_type   = document.getElementById('calculator_rental_type');
    let property_weekly_rent     = document.getElementById("calculator_property_weekly_rent");
    let bond_amount              = document.getElementById('calculator_bond_amount');
    let property_postcode        = document.getElementById('calculator_property_postcode');

    let start_of_lease           = document.getElementById('start_of_lease');
    let end_of_lease             = document.getElementById('start_of_lease');
    let calculator_rolling_lease_row = document.getElementById('calculator_rolling_lease_row');
    let calculator_rolling_lease = document.getElementById('calculator_rolling_lease');

    let calculator_results       = document.getElementById('calculator_results');
    let establishment_fee        = document.getElementById('calculator_establishment_fee');

    let previous_bond_amount     = document.getElementById('previous_bond_amount');
    let calculator_deposit       = document.getElementById('calculator_deposit');
    let calculator_total         = document.getElementById('calculator_total');

    let buy_back_bond_amount     = document.getElementById('calculator_buy_back_bond_amount');
    let calculator_annual_fee    = document.getElementById('calculator_annual_fee');
    let calculator_monthly_fee   = document.getElementById('calculator_monthly_fee');
    let calculator_months_until_expiry     = document.getElementById("calculator_months_until_expiry");
    let calculator_cash_back     = document.getElementById("calculator_cash_back");

    // UI's
    let calculator_button        = document.getElementById("calculator_button");
    let calculator_results_new_bond      = document.getElementById("calculator_results_new_bond");
    let calculator_results_existing_bond = document.getElementById("calculator_results_existing_bond");
    let calculator_apply_button = document.getElementById('calculator_apply_button');

    let calculator_weekly_rent  = document.getElementById("calculator_weekly_rent");
    let calculator_total_fee    = document.getElementById("calculator_total_fee");


    let calculator_months_until_expiry_row = document.getElementById("calculator_months_until_expiry_row");
    let calculator_deposit_row   = document.getElementById('calculator_deposit_row');
    let calculator_total_row     = document.getElementById('calculator_total_row');
    let calculator_cash_back_row = document.getElementById('calculator_cash_back_row');

    /*

    Housekeeping

    */

    function validate_field(field) {
      if (includes.is_blank(field.value)) {
        field.classList.add('is-invalid');
        error = true;
        return true;
      }
      return false;
    }

    async function url_request(contract) {
      let data = await includes.httpRequest("POST", url, { contract: contract });

      // console.log(data);

      if (data.error) {
        alert.classList.remove('hidden');
        alert_content.innerHTML = data.error;
      } else {
        calculator_results_new_bond.classList.remove('hidden');
        establishment_fee.innerHTML      = data.establishment_fee;
        calculator_weekly_rent.innerHTML = data.weekly_rent;
        calculator_total_fee.innerHTML   = data.fee;

        // full_fee
        // Accept and Apply Now!

        let container = document.getElementById('calculator_new_bond_buy_back_schedule');
        if (!container) { return; }
        if (!data.bond_buy_back) { return; }

        let string = "";
        let i = 1;
        for (var element of data.bond_buy_back) {
          string += `<tr>`;
          string +=   `<th scope='row'>${i++}</th>`;
          string +=   `<td>${element}</td>`;
          string +=   `<td></td>`;
          string += '</tr>';
        }

        container.innerHTML = string;
      }

      calculator_button.disabled = false;
      let overlay = document.getElementById('overlay_spinner');
      if (overlay) { overlay.classList.remove('d-flex'); }
    }

    /*

    UI Functions

    */

    function clear_errors() {
      // TODO - this could be optimised
      error = false;
      alert.classList.add('hidden');
      alert_content.innerHTML = '';
      property_weekly_rent.classList.remove('is-invalid');
      bond_amount.classList.remove('is-invalid');
      property_postcode.classList.remove('is-invalid');

      calculator_results_new_bond.classList.add('hidden');
      calculator_results_existing_bond.classList.add('hidden');
    }

    /*

    Event listeners

    */

    if (!calculator_rental_type) { return; }
    calculator_rental_type.addEventListener("change", () => {

      if (calculator_rental_type.value == "0") {
        calculator_rolling_lease_row.classList.add('hidden');
      }

      if (calculator_rental_type.value == "1") {
        calculator_rolling_lease_row.classList.remove('hidden');
      }
    });

    var targetNode = document.getElementById('calculator_quote_modal');
    var observer = new MutationObserver(function() {

      if (targetNode.classList.contains('show')) {
        let overlay = document.getElementById('overlay_spinner');
        if (overlay) { overlay.classList.add('d-flex'); }


        // modal is visible, so calculate
        // calculator_button.disabled = true;  // no double taps
        clear_errors();

        // update values
        let contract = {};

        switch(parseInt(calculator_rental_type.value)) {
          case 0:
          case 1:
          // validate fields
          validate_field(property_weekly_rent);
          validate_field(bond_amount);
          validate_field(property_postcode);

          if (error == false) {
            contract["status"]               = 0; // application
            contract["contract_type"]        = calculator_rental_type.value;
            contract["rental_bond"]          = bond_amount.value;
            contract["property_weekly_rent"] = property_weekly_rent.value;
            contract["property_postcode"]    = property_postcode.value;
            contract["start_of_lease"]       = start_of_lease.value;
            contract["end_of_lease"]         = end_of_lease.value;
            contract['rolling_lease']        = calculator_rolling_lease.checked;

            // set the hidden values
            document.getElementById('contact_contract_type').value     = calculator_rental_type.value;
            document.getElementById('contact_property_postcode').value = property_postcode.value;
            document.getElementById('contact_start_of_lease').value    = start_of_lease.value;
            document.getElementById('contact_end_of_lease').value      = end_of_lease.value;
            document.getElementById('contact_rolling_lease').value     = calculator_rolling_lease.checked;
            document.getElementById('contact_property_weekly_rent').value = property_weekly_rent.checked;
          }
            break;
          default:
            error = true;
        }


        if (error == false) {
          url_request(contract);
        } else {
          if (overlay) { overlay.classList.remove('d-flex'); }
          // TODO: hide modal
          // calculator_button.disabled = false;
        }

      }

    });

    observer.observe(targetNode, { attributes: true, childList: true });


    // if (!calculator_button) { return }
    // calculator_button.addEventListener("click", (e) => {
    //   e.preventDefault();
    //
    //   calculator_button.disabled = true;  // no double taps
    //   clear_errors();
    //
    //   // update values
    //   let contract = {};
    //
    //   switch(parseInt(calculator_rental_type.value)) {
    //     case 0:
    //     case 1:
    //     // validate fields
    //     validate_field(property_weekly_rent);
    //     validate_field(bond_amount);
    //     validate_field(property_postcode);
    //
    //     if (error == false) {
    //       contract["status"]               = 0; // application
    //       contract["contract_type"]        = calculator_rental_type.value;
    //       contract["rental_bond"]          = bond_amount.value;
    //       contract["property_weekly_rent"] = property_weekly_rent.value;
    //       contract["property_postcode"]    = property_postcode.value;
    //       contract["start_of_lease"]       = start_of_lease.value;
    //       contract["end_of_lease"]         = end_of_lease.value;
    //       contract['rolling_lease']        = calculator_rolling_lease.checked;
    //
    //       // set the hidden values
    //       document.getElementById('contact_contract_type').value     = calculator_rental_type.value;
    //       document.getElementById('contact_property_postcode').value = property_postcode.value;
    //       document.getElementById('contact_start_of_lease').value    = start_of_lease.value;
    //       document.getElementById('contact_end_of_lease').value      = end_of_lease.value;
    //       document.getElementById('contact_rolling_lease').value     = calculator_rolling_lease.checked;
    //       document.getElementById('contact_property_weekly_rent').value = property_weekly_rent.checked;
    //     }
    //       break;
    //     default:
    //       error = true;
    //   }
    //
    //   if (error == false) {
    //     url_request(contract);
    //   } else {
    //     calculator_button.disabled = false;
    //   }
    //
    // });


    // if (!calculator_apply_button) { return }
    // calculator_apply_button.addEventListener('click', () => {
    //   console.log('calculator_apply_button');
    //
    //   contract = {}
    //   contract["status"]               = 0; // application
    //   contract["contract_type"]        = calculator_rental_type.value
    //   contract["rental_bond"]          = bond_amount.value;
    //   contract["property_weekly_rent"] = property_weekly_rent.value;
    //   contract["property_postcode"]    = property_postcode.value;
    //   contract["start_of_lease"]       = start_of_lease.value;
    //   contract["end_of_lease"]         = end_of_lease.value;
    //   contract['rolling_lease']        = calculator_rolling_lease.checked;
    //
    //   // post to somewhere..??
    //
    //
    // });

    /*
      Always send numbers to server for calcuation

      This means we only ever use one set of calculations (DRY)
    */

    async function calculate_server() {
      let rental_bond = parseFloat(document.getElementById('calculator_bond_amount').value);
      let weekly_rent = rental_bond / 4;

      let contract = {};
      contract["contract_type"] = document.getElementById('calculator_rental_type').value;
      contract["value"]         = parseFloat(document.getElementById('calculator_bond_amount').value);
      contract["status"]        = 0; // application
      contract["property_weekly_rent"] = weekly_rent;
      contract["rental_bond"]   = rental_bond;

      let data = await includes.httpRequest("POST", url, { contract: contract });
      console.log(data);
    }
  }
});
