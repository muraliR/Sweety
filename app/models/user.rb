class User < ActiveRecord::Base

  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable, :validatable,
         :recoverable, :rememberable, :trackable 

    def self.user_types
    	%w(Patient Doctor) #For Single Table Inheritance Types
	end

  	validates :user_type, :inclusion => {:in => User.user_types, :message => 'Please Specify you are a Doctor or Patient'}

    #implementing the single table inheritance
    self.inheritance_column = :user_type 

    def patient? #to check whether the object is patient
    	user_type == "Patient"
    end

    def doctor? #to check whether the object is doctor
    	user_type == "Doctor"
    end

    # def index_data(params=[])
    # 	#returns if the User Type is Empty
    # 	#SO Raise the Error
    # end
end


class Patient < User

	#scope :gls, -> (id) { joins(:glucose_levels).where('glucose_levels.patient_id = ?', id) }

	has_many :glucose_levels	

	def index_data(params=[])
		glucose_levels_data = glucose_levels
		#check any search params is coming from request
		if params.present?
	    	glucose_levels_data = glucose_levels.date_filter(params["start_date"],params["end_date"])
		end
		glucose_levels_data
    end

    def can_create_glucose_level?
    	#method to validate whether patient can create a new Glucose Level For that day
    	self.glucose_levels.where("created_at >= ?", Time.zone.now.beginning_of_day).count < GlucoseLevel.daily_limit
	end

end 

class Doctor < User 

	def index_data(params=[])
		#CurrentlyFetching all patients glucose levels
    	GlucoseLevel.all
    end
end 
