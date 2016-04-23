class GlucoseLevelsController < ApplicationController

	before_filter :authenticate_user! #Authorization to access all methods in this controller
	before_filter :can_create_glucose_level, :only => [:new, :create] # check for authorization to create new glucose level
	#before_filter :set_date_params, :only => [:index] #set the date params that can be accesed to view
	before_filter :filter_and_validate_params, :only => [:index] #Filter the Parms that is coming form request

	def index
		#get glucose levels data
		@glucose_levels = current_user.index_data(filter_and_validate_params)
		@max_reading = @glucose_levels.maximum(:glucose_level)
		@min_reading = @glucose_levels.minimum(:glucose_level)
		@avg_reading = @glucose_levels.average(:glucose_level)
	end


	def new
		#Create new GlucoseLevel
		@glucose_level = GlucoseLevel.new	
	end

	def create
		@gl = current_user.glucose_levels.build(glucuose_level_params)
		if @gl.save
			flash[:notice] = "Successfully Saved"
			redirect_to glucose_levels_path
		else
			#throw error if it is not saved
			flash[:error] = @gl.errors.full_messages.to_sentence
    		redirect_to new_glucose_level_path	
		end
	end

	private

	def glucuose_level_params
		#Strong Params Permit
		params.require(:glucose_level).permit(:glucose_level)
	end

	def can_create_glucose_level
		 #check has the patient reached the daily limit
		unless current_user.can_create_glucose_level?
			flash[:error] = "You have reached the Daily limit input of GlucoseLevel!!!"
			redirect_to glucose_levels_path
		end
	end

	def filter_and_validate_params
		@start_date = @end_date = Time.now.strftime('%Y-%m-%d')
		if params[:search].present?
			search_params = params.require(:search).permit(:start_date, :end_date)
			if validDate(search_params["start_date"]) && validDate(search_params["end_date"])
				@start_date = params['search']['start_date']
				@end_date = params['search']['end_date']
				search_params
			else
				flash[:error] = "Invalid Date!!"
				redirect_to glucose_levels_path
			end
		end
	end

end
