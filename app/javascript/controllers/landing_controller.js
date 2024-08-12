import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    const animationElement = document.querySelector('.landing-title');

      function showAnimation() {
        animationElement.classList.remove('d-none');
      }

      setTimeout(showAnimation, 2000);
  }
}
