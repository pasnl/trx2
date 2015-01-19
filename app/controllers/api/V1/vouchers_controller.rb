module Api
  module V1
    class VouchersController < Api::ApiController

      respond_to :json
      before_action :authenticate

      def index
        if checkuser(params[:barcode])
          @vouchers = @user.vouchers.where("valid_date > ?", DateTime.now) # haal alle vouchers op die nog niet zijn verlopen
          render json: @vouchers, :except => [:user_id, :updated_at ], status:200
        else
          render :json => {:status => "404", :error => "Spaarkaart niet gevonden error" }, :status => 404
        end
      end #show




      def update
        @voucher = Voucher.find(params[:id])
         if (@voucher.user_id == @user.id) && (checkuser(params[:barcode])) && (@voucher.check_voucher)

            @voucher.is_active = false
            @voucher.cash_date = DateTime.now
            if @voucher.save
              @activity = @voucher.activities.build(user_id: @user.id, minplus: 'min', tr_amount: @voucher.cash_value)
              @activity.save
              @user.update_balance_total
              render json: @voucher, :only => [:id, :cash_date, :is_active], status:200
            else
              render :json => {:status => "500", :error => "Interne fout" }, :status => 500
            end

        else
          render :json => {:status => "404", :error => "Voucher is niet geldig" }, :status => 404
        end # (@voucher.user_id == @u......
      end #update




      def destroy
        @voucher = Voucher.find(params[:id])
        @voucher.destroy
        render :json => {:status => "200", :error => "Voucher is succesvol verwijderd" }, :status => 200
      end



      private


    end #class
  end
end
