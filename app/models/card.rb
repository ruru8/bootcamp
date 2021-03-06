# frozen_string_literal: true

class Card
  def self.create(user, card_token, idempotency_key = SecureRandom.uuid)
    Stripe::Customer.create({
      email: user.email,
      source: card_token
    }, {
      idempotency_key: idempotency_key
    })
  end

  def self.update(customer_id, card_token)
    customer = Stripe::Customer.retrieve(customer_id)
    customer.source = card_token
    customer.save
  end

  def self.search(email:)
    result = Stripe::Customer.list(email: email, limit: 1)
    if result.data.size > 0
      result.data.first
    else
      nil
    end
  end
end
