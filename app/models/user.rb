# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  unconfirmed_email        :string(255)
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string(255)
#  locked_at                :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  cardnumber               :string(255)
#  balance                  :decimal(, )      default(0.0), not null
#  updated_balance_datetime :datetime
#  is_active                :boolean
#  gender                   :string(1)
#  date_of_birth            :date
#  device_id                :string(255)
#  api_key                  :string(255)
#  program_id               :integer
#  balance_total            :decimal(, )
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable , :confirmable


  belongs_to :program
  has_many :activities
  has_many :vouchers

  validates :email, uniqueness: {scope: :program_id}, :allow_blank => true, :if => :email_changed?, :on=>:update
  validates_format_of :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?, :on=>:update


  before_create do |doc|
    doc.api_key = doc.generate_api_key
  end


  def self.device_in_program(program, device)
    where("program_id = ? AND device_id = ?", program, device)
  end



  def self.barcode_in_program(program, barcode)
    where("program_id = ? AND cardnumber = ?", program, barcode)
  end


  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token) #.any?
    end
  end



  def update_balance_total

    if self.vouchers.where("is_active = ?",true) != nil
      vouchers = self.vouchers.where("is_active = ?",true)
    else
      vouchers = none
    end

    sub_total = 0

    vouchers.each do |voucher|
      sub_total = sub_total + voucher.cash_value
    end

    self.balance_total = sub_total + self.balance
    #return total
    self.save

  end #update_balance_total(user)




  def card_full # controleer of de spaarkaart vol is
    program = Program.find(self.program_id)

    if self.balance >= program.punch_card
      return true
    else
      return false
    end
  end #card_full



  def create_voucher_from_punchcard

    program = Program.find(self.program_id)
    voucher = self.vouchers.build(
        cash_value: program.punch_card,
        content_id: 1, #nog dynamish maken
        valid_date: DateTime.now + program.voucher_days )
    voucher_activity = voucher.activities.build(user_id: self.id, minplus: 'transform', tr_amount: 0)

    self.balance = self.balance - program.punch_card.to_d
    self.updated_balance_datetime = DateTime.now

    return voucher, voucher_activity

  end # def create_voucher_from_punchcard






end #class
