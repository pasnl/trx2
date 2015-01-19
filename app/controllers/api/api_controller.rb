class Api::ApiController < ActionController::Base

  private

  # authentication via HTTP header
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.where(api_key: token).first
    end
  end

  #hoort de gebruiker bij deze barcode
  def checkuser(barcode)
    return true if @user  == User.where(cardnumber: barcode).take
  end #checkuser(barcode)


def calculate_ean13
  code12 = Array.new(12, 10).map { |n| rand(n) }
  sum = 0

  12.times do |index|
    if (index % 2 == 1) then
      sum = sum + (3*code12[index])
    else
      sum = sum + code12[index]
    end
  end

  checkbit = 10 -(sum % 10)
  checkbit = 0 if checkbit == 10

  code13 = code12.push(checkbit).join.to_s
  return code13
  #TODO eigenlijk nog even checken of deze code al niet eerder is uitgegeven
end  #calculate_ean13 # created by m.dekker


end #Api::ApiController < ActionController::Base


