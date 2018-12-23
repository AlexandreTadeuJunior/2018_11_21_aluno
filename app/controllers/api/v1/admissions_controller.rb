class Api::V1::AdmissionsController < ApplicationController
  before_action :set_admission, only: [:show]

  # GET /admission
  def index
    @admission = Admission.all
    json_response(@admission)
  end
end
