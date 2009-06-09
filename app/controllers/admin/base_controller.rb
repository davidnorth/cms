class Admin::BaseController < ApplicationController
  
  before_filter :require_user
  before_filter :require_admin

  layout :set_popup_layout

  helper :easy_forms
  helper "admin/filters"
  

  # For all controllers using ResourceController
  # Call this instead of resource_controller
  # to override various default behaviour
  # Set up pagination when finding collection including automatic filtering of records using named scopes
  def self.setup_resource_controller
    resource_controller
    # Go back to index rather than 'show' after creating or updating
    create.response do |wants|
      wants.html { redirect_to collection_url }
    end
    update.response do |wants|
      wants.html { redirect_to collection_url }
    end
    # Use will_paginate rather than regular find for lists
    define_method :collection do
      paginate_collection_with_filters
    end
  end
  
  #
  # Override these defaults in a RC controller as needed
  #

  def human_model_name
    model_name.humanize
  end

  def list_columns
    [:to_s]
  end

  helper_method :human_model_name, :list_columns



  # Handle checkboxes next to file upload widgets were there is an existing file
  def handle_file_deletions(model)
    record = instance_variable_get("@#{model}")
    if params["#{model}_delete"]
      params["#{model}_delete"].keys.each do |column|
        if record.respond_to?(column) and record.send(column) and File.exists?(record.send(column))
          File.delete(record.send(column))
          #record.update_attribute(column, nil)
        end
      end
    end
  end

  def set_popup_layout
    if params[:popup] and !params[:popup].blank?
      'admin_dialog'
    else
      'admin'
    end
  end

  #
  # Render a csv file as a download
  # supply array of arrays for data
  # comma separated string for headers
  # filename with no extension
  #
  def render_csv(data,headers,filename)
    csv_writer = ::CSV::Writer.generate(output = '')
    csv_writer << headers.split(',')
    data.each {|row| csv_writer << row}
		send_data(output, :type => "text/plain", :filename => "#{filename}")
  end


  def require_admin
    current_user && current_user.admin? ? true : access_denied
  end
  
  

end