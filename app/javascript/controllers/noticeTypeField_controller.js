import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['optionField']

  addOptionFields(event) {
    if(event.target.value == 'options'){
      this.optionFieldTarget.classList.remove('d-none')
    } else {
      this.optionFieldTarget.classList.add('d-none')
    }
  }
}
