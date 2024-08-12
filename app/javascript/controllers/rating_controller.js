import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    document.querySelectorAll('.rating-btn').forEach(function (button) {
      button.addEventListener('click', function () {
        document.getElementById('rating_input').value = this.value;
        this.closest('form').submit();
      });
    });
  }
}
