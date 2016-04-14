class User < ActiveRecord::Base

	include Tool #include Tool Module for Helper Methods

  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable, :validatable,
         :recoverable, :rememberable, :trackable 

    USER_TYPES = %w(Patient Doctor) #For Single Table Inheritance Types

  	validates :user_type, :inclusion => {:in => USER_TYPES, :message => 'Please Specify you are a Doctor or Patient'}

    #implementing the single table inheritance
    self.inheritance_column = :user_type 

    def patient? #to check whether the object is patient
    	user_type == "Patient"
    end

    def doctor? #to check whether the object is doctor
    	user_type == "Doctor"
    end

    def index_data(params=[])
    	#returns if the User Type is Empty
    	#SO Raise the Error
    end
end


class Patient < User

	has_many :glucose_levels

	def index_data(params=[])
		glucose_levels_data = glucose_levels
		#check any search params is coming from request
		unless params["search"].nil?
			search_params = params["search"]

			#first search for dates
			#check id date params coming from request
			#if date params coming from request, validate the start date and end date
			if validDate(search_params["start_date"]) && validDate(search_params["end_date"])
				start_date = search_params["start_date"]
	    		end_date = search_params["end_date"]
	    		glucose_levels_data = glucose_levels_data.where('DATE(created_at) BETWEEN ? AND ?', start_date, end_date)	
			end

			#### any other search goes here

		end
		glucose_levels_data
    end

    def can_create_glucose_level?
    	#method to validate whether patient can create a new Glucose Level For that day
    	self.glucose_levels.where("created_at >= ?", Time.zone.now.beginning_of_day).count < GlucoseLevel::DAILYLIMIT
	end

end 

class Doctor < User 

	def index_data(params=[])
		#CurrentlyFetching all patients glucose levels
    	self.glucose_levels
    end

	def glucose_levels
		#for Doctors Get all the Glucose Levels
		GlucoseLevel.all
	end
end 
