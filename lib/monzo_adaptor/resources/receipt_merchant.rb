# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # The merchant info attached to a Receipt — a different shape from
    # MonzoAdaptor::Resources::Merchant (the merchant on a Transaction),
    # per Monzo's own docs. This is free-text contact/display info the
    # receipt submitter provides for that one receipt (no id, no
    # relationship to Monzo's merchant directory), not a lookup into it.
    #
    # @see https://docs.monzo.com/#receipt-merchant
    ReceiptMerchant = Data.define(:name, :online, :phone, :email, :store_name, :store_address, :store_postcode) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
