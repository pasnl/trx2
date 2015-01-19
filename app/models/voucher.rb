# == Schema Information
#
# Table name: vouchers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cash_date  :datetime
#  cash_value :decimal(, )
#  content_id :integer
#  created_at :datetime
#  updated_at :datetime
#  pod_id     :string(255)
#  valid_date :datetime
#  is_active  :boolean          default(TRUE)
#  title      :string(255)      default("Volle spaarkaart")
#  subtitle   :string(255)      default("GRATIS kopje koffie bij volle spaarkaart")
#

class Voucher < ActiveRecord::Base

  has_many :activities, as: :tr_activity
  belongs_to :user




  def check_voucher
    time_not_expired = DateTime.now < self.valid_date #false is 'verlopen'

    if time_not_expired && self.is_active
      return true
    else
      return false
    end
  end #check_voucher(voucher)





end
