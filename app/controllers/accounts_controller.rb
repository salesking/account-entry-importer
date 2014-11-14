class AccountsController < ApplicationController
  respond_to :json

  def autocomplete
    initialize_salesking_connection
    @results = Sk.const_get("Account").where(permitted_params.merge(filter: {status_draft: 1}))
    render json: {results: process_results, total_pages: @results.total_pages}
  end

  protected

  def process_results
    @results.map do |account|
      {
        id: account.id,
        number: account.number,
        name: (account.name.presence || '[ >> ]'),
        balance: account.balance,
        budget: account.budget,
        default_price: account.default_price
      }
    end
  end

  def permitted_params
    params.permit(:q, :per_page, :page, :type, :format, :_)
  end

end
