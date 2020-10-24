
document.addEventListener("DOMContentLoaded", () => {

  let checkoutButton = document.getElementById("checkout-button");
  if (!checkoutButton) { return }


  checkoutButton.addEventListener('click', function() {
    // Extract session Id
    let session_element = document.getElementById('stripe_session_id');
    if (!session_element) { return; }
    let stripe_session_id = session_element.innerHTML;

    // Extract public key
    let public_key_element = document.getElementById('stripe_public_key');
    if (!public_key_element) { return; }
    let stripe_public_key = public_key_element.innerHTML;

    console.log(stripe_session_id);
    console.log(stripe_public_key);

    // let stripe = Stripe('pk_test_51HfNuULGovslRiHyH9vr7DJMUyFjis9DGS4xer9qS1bnHdq0CSeE4b2HnTy5aTdaIPaJc9gFHlGhB6D6rvCrnyYb00txWG3U2x');
    let stripe = Stripe(stripe_public_key);

    // Create a new Checkout Session using the server-side endpoint you
    // created in step 3.

    stripe.redirectToCheckout({
      // Make the id field from the Checkout Session creation API response
      // available to this file, so you can provide it as argument here
      // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
      sessionId: stripe_session_id
    }).then(function (result) {
      // If `redirectToCheckout` fails due to a browser or network
      // error, display the localized error message to your customer
      // using `result.error.message`.
      if (result.error) {
        alert(result.error.message);
      }

    }).catch(function(error) {
      console.error('Error:', error);
    });
  });
});
