import Includes from './includes';

document.addEventListener("DOMContentLoaded", () => {

  let form = document.getElementById('apply_form');
  if (form) {
    form.addEventListener('submit', () => {
      let overlay = document.getElementById('overlay_spinner');
      if (overlay) { overlay.classList.add('d-flex'); }
    })
  }

});
