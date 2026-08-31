# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # A place to keep some money separate from the main spending account.
    #
    # @see https://docs.monzo.com/#pots
    Pot = Data.define(
      :id, :name, :style, :balance, :currency, :type, :product_id,
      :assigned_permissions, :current_account_id, :cover_image_url,
      :isa_wrapper, :charity_id, :goal_amount, :created, :updated,
      :deleted, :locked, :is_tax_pot, :round_up, :round_up_multiplier,
      :available_for_bills
    ) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
