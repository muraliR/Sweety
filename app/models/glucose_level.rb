class GlucoseLevel < ActiveRecord::Base

	scope :date_filter, -> (start_date,end_date) { where('DATE(created_at) BETWEEN ? AND ?', start_date, end_date) }

	belongs_to :patient 

	validates :glucose_level,presence: true, inclusion: { in: (5..9).to_a,
    message: "%{value} is not a valid level" } #validation from patients input

    validates :patient_id,presence: true 

   	def self.daily_limit
    	4
	end

end
