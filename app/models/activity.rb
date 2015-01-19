# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  tr_activity_id   :integer
#  tr_activity_type :string(255)
#  minplus          :string(255)
#  tr_amount        :decimal(, )
#

class Activity < ActiveRecord::Base

  belongs_to :tr_activity, polymorphic: true
  belongs_to :user

end
