module NamedScopeHelpers

  def self.append_features(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    # Add a named scope with an argument that will match the specified field
    def named_scope_with_exact_match(name, field)
      named_scope name, lambda { |q| { :conditions => {field => q} } }
    end

    # Add a named scope with an argument that will match one or more fields using LIKE
    def named_scope_with_like_match(name, *fields)
      named_scope name, lambda { |q| { :conditions => [fields.map{|f| "#{f} LIKE :q"}.join(" OR " ), {:q => "%#{q}%"}] } }
    end

    def named_scope_for_limit
      named_scope :limit, lambda {|number| {:limit => number} }
    end

    def named_scope_for_ordering(name, column)
      named_scope name, lambda { |direction| { :order => "#{column} #{direction}" } }
    end
    
  end

end