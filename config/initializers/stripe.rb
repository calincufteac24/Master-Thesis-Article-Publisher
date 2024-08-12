Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials[:stripe_pk],
  scret_key: Rails.application.credentials[:stripe_sk]
}

Stripe.api_key = Rails.application.credentials[:stripe_sk]
