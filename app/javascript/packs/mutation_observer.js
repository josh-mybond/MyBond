/*

  This routine watches the DOM for changes.

  This enables us to update the top line progress bar when

  the user has progressed on pages we don't control

*/

document.addEventListener("DOMContentLoaded", () => {

  // Application Form Mutation Observer
  console.log("mutation_observer: 1");
  let ml_app = document.getElementById('MLApp');
  console.log("mutation_observer: 2");
  console.log(ml_app);

  if (ml_app) {
    console.log("mutation_observer: 3");

    // mutation observer options
    let options = {
      childList: true,
      attributes: true,
      characterData: false,
      subtree: false,
      attributeFilter: ['one', 'two'],
      attributeOldValue: false,
      characterDataOldValue: false
    };


    // watch the application form
    observer = new MutationObserver(mCallback);

    // observer callback
    function mCallback(mutations) {
      for (let mutation of mutations) {
        if (mutation.type === 'childList') {
          console.log('Mutation Detected: A child node has been added or removed.');

          /*


            ml__progress_step_0 has class ml__progress_active
              we entering customer details

            ml__progress_step_1 has class ml__progress_active
              we confirming customer

            ml__progress_step_2 has class ml__progress_active
              we are on step 1 - we are

            ml__progress_step_3 has class ml__progress_active
              we are on step 3 - we are


          */
        }
      }
    }

    observer.observe(ml_app, options);
  }

});
