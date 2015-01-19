class PunchesController < ApplicationController
  before_action :set_punch, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @punches = Punch.all
    respond_with(@punches)
  end

  def show
    respond_with(@punch)
  end

  def new
    @punch = Punch.new
    respond_with(@punch)
  end

  def edit
  end

  def create
    @punch = Punch.new(punch_params)
    @punch.save
    respond_with(@punch)
  end

  def update
    @punch.update(punch_params)
    respond_with(@punch)
  end

  def destroy
    @punch.destroy
    respond_with(@punch)
  end

  private
    def set_punch
      @punch = Punch.find(params[:id])
    end

    def punch_params
      params.require(:punch).permit(:punch_code, :cash_value, :program_id)
    end
end
