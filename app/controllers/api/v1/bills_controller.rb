class Api::V1::BillsController < ApplicationController
  before_action :set_bills, only: [:show, :edit, :update]

  # GET /bills
  def index
    @bills = Bill.all
    json_response(@bills)
  end

  # GET /bills/1
  def show
    json_response(@bills)
  end

  # PATCH/PUT /bills/1
  def update
    # verify due date bills
    day_now = Date.today
    if @bills[:due_date] < day_now
      render json: {status: "error", code: 422, message: "Sorry, you no change payment method in bills from past"} and return
    end

    # verify method payment is c or b
    if bills_params[:payment_method] != "c" and bills_params[:payment_method] != "b"
      render json: {status: "error", code: 422, message: "Please, method payment is 'c' for cartão or 'b' for boleto"} and return
    end

    # Save method payment
    @bills.update(bills_params)
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bills
      @bills = Bill.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bills_params
      params.require(:bills).permit(:payment_method)
    end
end
