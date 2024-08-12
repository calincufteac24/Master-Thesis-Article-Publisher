import { Controller } from "stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = {
    url: String,
    organizationUrl: String,
    organizationRole: String
  }

  static targets = ["sign_up_button", "personal_id_container", "passport_id_container", "password_field"]

  static last_fiscal_code = '';

  connect() {
    this.sign_up_buttonTarget.disabled = document.getElementById('user_accept_terms').checked == false
  }

  changeRole(event) {
    get(`${this.urlValue}`, {
      responseKind: "turbo-stream",
      query: {
        template: event.target.value
      }
    })
  }

  acceptTerms(event) {
    this.sign_up_buttonTarget.disabled = event.target.checked == false
  }

  changeIdentityType(event) {
    if(event.target.value == 'personal_id') {
      this.personal_id_containerTarget.classList.remove("d-none")
      this.passport_id_containerTarget.classList.add("d-none")
    } else if(event.target.value == 'passport_id') {
      this.personal_id_containerTarget.classList.add("d-none")
      this.passport_id_containerTarget.classList.remove("d-none")
    }
  }

  searchCompany(event) {
    let value = event.target.value;
    if(value.length >= 8 && value != this.last_fiscal_code) {
      get(`${this.organizationUrlValue}`, {
        responseKind: "turbo-stream",
        query: {
          q: event.target.value,
          role: event.target.getAttribute('data-organization-role')
        }
      })
      this.last_fiscal_code = value;
    }
  }

  togglePassword(event) {
    let show_eye = document.getElementById('show_eye')
    let hide_eye = document.getElementById('hide_eye')
    if(this.password_fieldTarget.type == 'password') {
      show_eye.classList.add("d-none");
      hide_eye.classList.remove("d-none");
      this.password_fieldTarget.type = 'text';
    } else {
      hide_eye.classList.add("d-none");
      show_eye.classList.remove("d-none");
      this.password_fieldTarget.type = 'password';
    }
  }
}
