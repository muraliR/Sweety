class GlucoseLevel < ActiveRecord::Base

	belongs_to :patient 

	validates :glucose_level,presence: true, inclusion: { in: (5..9).to_a,
    message: "%{value} is not a valid level" } #validation from patients input

    validates :patient_id,presence: true 

   	DAILYLIMIT = 4 #Constant to set the Daily Limit

end
