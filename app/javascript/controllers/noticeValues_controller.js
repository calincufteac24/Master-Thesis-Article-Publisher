import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['optionField']

  connect() {
    $('#field_values_container [data-toggle=datepicker]').datepicker();
  }
}
