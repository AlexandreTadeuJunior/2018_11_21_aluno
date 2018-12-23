class Api::V1::AdmissionsController < ApplicationController
  before_action :set_admission, only: [:show, :edit, :update]

  # GET /admission
  def index
    @admission = Admission.all
    json_response(@admission)
  end

  # POST /admission
  def create
    # verify student's grade
    if admission_params[:enem_grade].to_i >= 450
      step = 'Y' # save step with Y for YES approved
    else
      step = 'N' # save step with N for NO approved
    end

    # Save admission student
    @admission = Admission.new(admission_params.merge(step: step))
    @admission.save
    json_response(@admission, :created)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admission
      @admission = Admission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admission_params
      params.require(:admission).permit(:enem_grade, :student_id)
    end
end
