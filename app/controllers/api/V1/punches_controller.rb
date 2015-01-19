module Api
  module V1
    class PunchesController < Api::ApiController

      respond_to :json
      before_action :authenticate


      def show
        @punch = Punch.where(punch_code: params[:id]).take
        if @punch != nil
         render json: @punch
        end
      end




      def update
       @punch = get_it(params[:id],@user,params[:barcode])
       if @punch == []
         render :json => {:status => "400", :error => "Geen geldige stempel" }, :status => 400
       else
         #verwerk spaarzegel en geef een transactie terug
         punch_transaction = @punch.process_punch(@user)

         if @user.card_full == true
            @voucher,voucher_transaction = @user.create_voucher_from_punchcard
         end

         if @user.save
            @punch.save
            punch_transaction.save

            if @voucher.present? == true
             @voucher.save
             voucher_transaction.save
            end

            @user.update_balance_total

            render json: {
                         :current_balance => @user.balance ,
                         :balance_total => @user.balance_total,
                         :updated_balance_datetime => @user.updated_balance_datetime,
                         :is_active => @user.is_active}, status:200
         else
           render :json => {:status => "500", :error => "Er is iets misgegaan, stempel is niet verwerkt" }, :status => 500
         end
       end #@punch == []
      end # def update





private

      def get_it(punch_code_in_params,user,barcode)
        if barcode.present?
          punch = Punch.where(:punch_code => punch_code_in_params).take
          if (punch != nil)  &&  (punch.cash_value > 0)   &&  (user.program_id == punch.program_id) && (barcode == user.cardnumber)
            return punch
          else
            return []
          end # (punch !=nil......

        else
            return []
        end # params[:id].present?
      end #get_it








    # end class
    end
  end
end

