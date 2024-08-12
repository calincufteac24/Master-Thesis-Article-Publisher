import { Controller } from "stimulus"
import { post } from "@rails/request.js"

export default class extends Controller {
  static values = { publishableKey: String, url: String }
  async connect() {

    const stripe = Stripe(this.publishableKeyValue)
    const response = await post(this.urlValue)

    const { clientSecret } = await response.json;

    const checkout = await stripe.initEmbeddedCheckout({
      clientSecret,
    });

    checkout.mount(this.element);
  }
}
