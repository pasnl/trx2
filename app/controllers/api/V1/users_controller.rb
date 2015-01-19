module Api
  module V1
    class UsersController < Api::ApiController
      respond_to :json

    before_action :authenticate, only: [:show, :update]


    def index
        render json: { :api_versie => "v1.0" }, status:200
    end




    # aanmaken van een nieuwe gebruiker en terugsturen van token en kaartnummer
    def create
       @card = check_params_and_create(params)

       if @card != nil
         render json: {
                     :api_key => @card.api_key ,
                     :barcode => @card.cardnumber,
                     :is_active => @card.is_active,
                     :current_balance => @card.balance,
                     :balance_total => @card.balance_total,
                     :max_balance => @card.program.punch_card}, status:201
      else
         render json: "Kan de stempelkaart niet aanmaken!", status:409
      end #@card != nil

    end #create



    def show

        if checkuser(params[:id])
         render json: {
                       :current_balance => @user.balance ,
                       :balance_total => @user.balance_total ,
                       :max_balance => @user.program.punch_card,
                       :updated_balance_datetime => @user.updated_balance_datetime ,
                       :is_active => @user.is_active}, status:200
        else
          render :json => {:status => "404", :error => "Gebruiker niet gevonden" }, :status => 404
        end
    end #show



    def update

      if checkuser(params[:id])

            activity_value = 0
            if @user.is_active == false
              @user.balance = @user.balance + @user.program.free_punch_profile
              activity_value = @user.program.free_punch_profile
            end

            if @user.card_full == true
              @voucher,voucher_transaction = @user.create_voucher_from_punchcard
            end


            if @user.update_attributes(
                :email => params[:email],
                :gender => params[:gender],
                :date_of_birth => params[:dateofbirth],
                :is_active => true,
                :balance => @user.balance,
                :updated_balance_datetime => DateTime.now )

              Activity.create(
                  user_id: @user.id,
                  minplus: 'plus',
                  tr_amount: activity_value,
                  tr_activity_id: @user.program.id,
                  tr_activity_type: "Program")

              if @voucher.present? == true
                @voucher.save
                voucher_transaction.save
              end



              @user.update_balance_total

              render json: {
                         :current_balance => @user.balance ,
                         :balance_total => @user.balance_total,
                         :updated_balance_datetime => @user.updated_balance_datetime,
                         :max_balance => @user.program.punch_card,
                         :is_active => @user.is_active}, status:200
              else
              render :json => {:status => "400", :error => "Kan profiel niet verrijken, probeer een ander email adres" }, :status => 400
            end #@user.update_attributes(

          else
              render :json => {:status => "404", :error => "Gebruiker niet gevonden" }, :status => 404

      end
      end #update





  private

     # returns user object or nil
     def check_params_and_create(params)

         # is there a valid category_id
         program = Program.where(name: params["category_id"]).take
         if program.present?

           # is there a valid barcode
           card = User.barcode_in_program(program, params["barcode"]).take

           if card.present?
             return card
           end #card.any?

           # is there a device_id
           card = User.device_in_program(program, params["device_id"]).take

           if card.present?
             return card
           elsif params["device_id"].present?
             barcode = calculate_ean13
             card = create_new_card(barcode, program, params["device_id"])
             return card
           end #(card.any?) &&

           return nil ## niet genoeg informatie, foutief verzoek

         else
           return nil ## category_id is altijd verplicht
         end #Program.where(name: pa

      end #check_params_before_create(params)




      def create_new_card(barcode, program, device_id)

            card = program.users.build(
            device_id: device_id,
            cardnumber: barcode,
            is_active: false,
            balance: program.free_punch_new,
            balance_total: program.free_punch_new)

            if card.save
              return card
            else
              return nil
            end
      end



    # einde class
    end
  end
end


#todo als een gebruiker met een goede barcode aanmeld maar met een ander device-id moet dit worden veranderd in de database
#todo als een onverzilverde coupon is verlopen moet het saldo totaal worden bijgewerkt