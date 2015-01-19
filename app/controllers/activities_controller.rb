class ActivitiesController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activities = Activity.all
    respond_with(@activities)
  end

  def show
    respond_with(@activity)
  end

  def new
    @activity = Activity.new
    respond_with(@activity)
  end

  def edit
  end

  def create
    @activity = Activity.new(transaction_params)
    @activity.save
    respond_with(@activity)
  end

  def update
    @activity.update(transaction_params)
    respond_with(@activity)
  end

  def destroy
    @activity.destroy
    respond_with(@activity)
  end

  private
    def set_transaction
      @activity = Activity.find(params[:id])
    end

    def transaction_params
      params.require(:activity).permit(:voucher_id, :user_id, :tr_date, :tr_type)
    end
end
