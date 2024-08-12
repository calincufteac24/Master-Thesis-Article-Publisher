import { Controller } from "stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = {
    fieldsUrl: String,
  }

  changeFields(event) {
    if(event.target.value.length > 0) {
      get(`${this.fieldsUrlValue}`, {
        responseKind: "turbo-stream",
        query: {
          ad_type_id: event.target.value
        }
      });
    } else {
      document.getElementById('field_values_container').innerHTML = '';
    }
  }
}
