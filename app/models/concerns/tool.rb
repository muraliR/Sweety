module Tool

	#Seperate Piece of Code (Independent) Goes here
  	
	#Method to check the date is valid or not
  	def validDate(date)
  		DateTime.parse date rescue false
  	end
end