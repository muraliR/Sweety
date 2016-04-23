class GlucoseLevel < ActiveRecord::Base

	scope :date_filter, -> (start_date,end_date) { where('DATE(created_at) BETWEEN ? AND ?', start_date, end_date) }

	belongs_to :patient 

	validates :glucose_level,presence: true, inclusion: { in: (5..9).to_a,
    message: "%{value} is not a valid level" } #validation from patients input

    

    validates :patient_id,presence: true 

   	DAILYLIMIT = 4 #Constant to set the Daily Limit

   	def self.max_level
   		max_by(&:glucose_level).glucose_level
   	end

   	def self.min_level
   		min_by(&:glucose_level).glucose_level
   	end

end
