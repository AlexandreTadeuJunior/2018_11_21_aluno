class Api::V1::BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update]

  # GET /billing
  def index
    @billing = Billing.all
    json_response(@billing)
  end

  # POST /billing
  def create
    # get last admission user and verify user's grade
    data_admission = Admission.where(["student_id = ?", billing_params[:student_id]]).last

    # verify student admission is <= 450
    if data_admission[:enem_grade] <= 450
      render json: {status: "error", code: 422, message: "Student no approved"} and return
    end

    # verify day
    if billing_params[:desired_due_day].to_i > 31
      render json: {status: "error", code: 422, message: "Day desired not valid"} and return
    end

    # verify number of installments
    if billing_params[:installments_count].to_i > 12 or billing_params[:installments_count].to_i < 1
      render json: {status: "error", code: 422, message: "Installments not valid, please select a numbers between 1 of 12"} and return
    end

    # Save admission student
    @billing = Billing.new(billing_params)
    @billing.save

    # created a bills
    day_now = Date.today

    # verify if desired_due_day is < day_now, if is true sum a 31 days of day bulls
    if billing_params[:desired_due_day].to_i < day_now.day
      day_now = day_now.next_month
    end

    # Created a bills of billing, create default method payment with boleto
    for count in 1..billing_params[:installments_count].to_i
      # save bills
      @bills = Bill.new({billing_id: @billing[:id],due_date: day_now, payment_method: "b", month: day_now.month, year: day_now.year})
      @bills.save

      # sum a 1 month to data_now
      day_now = day_now.next_month
    end

    # Return params for user
    json_response(@billing, :created)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def billing_params
      params.require(:billing).permit(:student_id, :desired_due_day, :installments_count)
    end
end
