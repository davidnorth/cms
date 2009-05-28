#
# A convenient approach to searching and pagninating models without having requiring 
# SQL snippets or other knowlege of the database schema outside the model
#

module ModelSearch

  def self.append_features(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    #
    # Search using convenient :filters and :ordering options
    # FILTER_MAPPINGS and ORDERING_MAPPINGS define the possible options for :filters and :orderings
    #
    def search(options = {})
      options.assert_valid_keys [:filters, :orderings, :limit, :offset, :pager]
      default_options = {:filters => {},:orderings => {}}
      options = default_options.update(options)
      # Build find options
      final_options = {}
      # Eager loading joins
      if self.constants.include?('EAGER_LOADING_JOINS')
        final_options[:include] = self::EAGER_LOADING_JOINS
      end
      # WHERE conditions
      if(options[:filters])
    		final_options[:conditions] = build_conditions_from_filters(options[:filters])
    	end
    	# Orderings
      unless options[:orderings].empty?
    	  # Orderings can be suplied as a single hash or an array of hashes, each hash is one ordering like :number => :desc
    		final_options[:order] = [options[:orderings]].flatten.map{|o| o.to_a.map{|i| self::ORDERING_MAPPINGS[i[0]] + " #{i[1]}"}}.join(",")
    	end
    	# If a pager object is supplied in option :pager, use that for limit and offset
    	if pager = options[:pager]
    		final_options[:limit], final_options[:offset] = pager.current.to_sql
    	end
      # Find the resources
      find(:all, final_options)
    end

    # Use the same filters as self.search to get a row count for paginating search results
    def search_count(filters = {})
      final_options = {:conditions => build_conditions_from_filters(filters)}
      # Eager loading joins
      if self.constants.include?('EAGER_LOADING_JOINS')
        final_options[:include] = self::EAGER_LOADING_JOINS
      end
      filters.assert_valid_keys(self::FILTER_MAPPINGS.keys)
      count(final_options)
    end

  	#
  	# Turn filters hash into an array for use in find conditions 
  	# First item is the where sql snippet
  	# Second item is the filters hash
  	#
  	def build_conditions_from_filters(supplied_filters = {})
  	  filters = supplied_filters.clone
      # Process the filters a bit
      filters.each do |key,val|
    	  # Automatically wrap '%%' around filter values where that filter is using LIKE
        if self::FILTER_MAPPINGS[key] =~ /LIKE/
          filters[key] = "%#{filters[key]}%"
        end
        # If an active record object is passed in as a filter value, use its id instead
        if val.kind_of? ActiveRecord::Base
          filters[key] = val.id
        end
        # Allow price search in pounds etc. rather than cents/pence
        if key == :price_from or key == :price_to
          filters[key] = val.to_f * 100
        end
      end
      sql_filters = filters.map {|key,val| self::FILTER_MAPPINGS[key]}
      [(['1=1'] + sql_filters).join(' AND '), filters] 
    end

  end

end

