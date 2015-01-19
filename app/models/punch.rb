# == Schema Information
#
# Table name: punches
#
#  id         :integer          not null, primary key
#  punch_code :string(255)
#  created_at :datetime
#  updated_at :datetime
#  cash_value :decimal(, )
#  program_id :integer
#

class Punch < ActiveRecord::Base

  has_many :activities, as: :tr_activity
  belongs_to :program


  def process_punch(user)
    user.balance = user.balance + self.cash_value
    user.updated_balance_datetime = DateTime.now
    punch_cash_value = self.cash_value
    self.cash_value = 0

    #maak een transactie aan als alles goed is gegaan (via de stempel)
    punch_activity = self.activities.build(user_id: user.id, minplus: 'plus', tr_amount: punch_cash_value)
    return punch_activity
  end #process_punch






end

