class MappingManager
	def initialize(params, mapping_params, current_user)
		@params = params
		@mapping_params = mapping_params
		@current_user = current_user
	end

	def get_mapping
		if @params[:reuse] && !@params[:existing_mapping_params].empty?
		  existing_mapping_params = @params[:existing_mapping_params].split(":")
		  mapping = find_or_create_mapping(existing_mapping_params)
		else
		  mapping = Mapping.new(@mapping_params)
		  mapping.user = @current_user
		end

		return mapping
	end
	

	private
	def find_or_create_mapping(existing_mapping_params)
	  existing_mapping_id = existing_mapping_params[0]
	  if existing_mapping_id && Mapping.find(existing_mapping_id)
	    mapping = Mapping.find existing_mapping_id
	    if mapping.account_id == @params[:mapping][:account_id] && (!mapping.account_id.empty? || !@params[:mapping][:account_id].empty?) 
	      mapping
	    else
	      new_mapping = mapping.dup
	      
	      new_mapping.account_id = @params[:mapping][:account_id]
	      new_mapping.account_name = @params[:mapping][:account_name]
	      new_mapping.account_default_price = @params[:mapping][:account_default_price]
	      new_mapping.account_budget = @params[:mapping][:account_budget]

	      mapping.mapping_elements.each do |mapping_element|
	        new_mapping.mapping_elements << mapping_element.dup
	      end

	      new_mapping
	    end
	  else
	    Mapping.new (@mapping_params)
	  end
	end	
end