module Api
  module V1
    class ActivitiesController < Api::ApiController

      respond_to :json
      before_action :authenticate


      def index
        @activities = Activity.all
        render json: @activities
      end




      private





      # end class
    end
  end
end