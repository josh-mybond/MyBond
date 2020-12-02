
export default class Includes {

  // Housekeeping

  is_blank(thing) {
    if (thing == null) { return true };
    if (thing == "")   { return true };
    return false
  }

  scrollToTop() { $(window).scrollTop(0); }

  // HTML Elements

  hide_element(id) {
    let element = document.getElementById(id);
    if (element) {element.hidden = true; }
  }

  show_element(id) {
    let element = document.getElementById(id);
    if (element) {element.hidden = false; }
  }

  set_value(id, string) {
    let element = document.getElementById(id);
    if (element) { element.value = string;}
  }

  set_innerHTML(id, string) {
    let element = document.getElementById(id);
    if (element) { element.innerHTML = string;}
  }

  //
  // Forms
  //

  async httpRequest(method, url, formData = {}) {
    let formObject = this.createFormObject(method, formData);
    const response = await fetch(url, formObject);
    return await response.json();
  }

  createFormObject(method, object) {
    let formObject = {
      method: method,
      headers: {
        "X-CSRF-Token": this.csrfToken(),
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    }

    if (method.toUpperCase() == "POST") { formObject.body = JSON.stringify(object) }
    return formObject;
  }

  csrfToken() {
    return document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
  }

  //
  // Validate
  //

  validateMobile(mobile) {
    // remove any non numeric characters from string
    mobile = mobile.replace(/\D/g,'');

    // format mobile number - for Australia at least.. might need extra work for other countries
    if (mobile.charAt(0) == "0") { mobile = mobile.substr(1) };

    // format XXX XXX XXX
    if (mobile.length > 3) {
      if (mobile.charAt(3) != " ") { mobile = mobile.slice(0, 3) + " " + mobile.slice(3); }
      if (mobile.charAt(7) != " ") { mobile = mobile.slice(0, 7) + " " + mobile.slice(7); }
    }

    // Ensure mobile is not to long..
    if (mobile.length > 11) { mobile = mobile.slice(0, 11); }
    return mobile;
  }



}
