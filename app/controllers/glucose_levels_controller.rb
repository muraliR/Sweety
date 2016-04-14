class GlucoseLevelsController < ApplicationController

	before_filter :authenticate_user! #Authorization to access all methods in this controller
	before_filter :can_create_glucose_level, :only => [:new, :create] # check for authorization to create new glucose level
	before_filter :set_date_params, :only => [:index] #set the date params that can be accesed to view

	def index
		#get glucose levels data
		@glucose_levels = current_user.index_data(params)
	end

	def new
		#Create new GlucoseLevel
		@glucose_level = GlucoseLevel.new	
	end

	def create
		#code to store the Gluocose Level Data in DB
		@gl = GlucoseLevel.new 
		@gl.glucose_level = glucuose_level_params["glucose_level"]
		@gl.patient_id = current_user.id
		#check the glucose level is saving or not
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

	def set_date_params
		#set the date params that can be accesed to view
		@start_date = @end_date = Time.now.strftime('%Y-%m-%d')
		if params["search"].present?
			@start_date = params['search']['start_date']
			@end_date = params['search']['end_date']
		end
	end

end
