module GlucoseLevelsHelper

	#Helper Method for displaying start date and end date in the input field
	def dateRangeValue(start_date,end_date)
		if start_date.present? && end_date.present?
			return start_date + ' ' + end_date
		end
	end
end
