module OrdersHelper
  def tax_rate_for_address(address)
    Rails.logger.debug "Address received in helper: #{address.inspect}"
    determine_tax_rate(address[:province], address[:country])
  end

  def determine_tax_rate(state, country)
    tax_rate = TaxRate.find_by(state: state, country: country)
    if tax_rate
      Rails.logger.debug "Tax Rate found: PST: #{tax_rate.pst}, GST: #{tax_rate.gst}, HST: #{tax_rate.hst}"
      tax_rate
    else
      Rails.logger.debug "No tax rate found for state: #{state}, country: #{country}, using defaults."
      tax_rate = TaxRate.new(pst: 0, gst: 0, hst: 0)
    end
  end

end

