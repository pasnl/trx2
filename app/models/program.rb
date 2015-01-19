# == Schema Information
#
# Table name: programs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  punch_card           :integer
#  free_punch_new       :integer
#  free_punch_profile   :integer
#  cardnumber_generator :integer
#  voucher_days         :integer          default(30)
#  card_prefix          :string(255)
#

class Program < ActiveRecord::Base

  has_many :punches
  has_many :users


end
