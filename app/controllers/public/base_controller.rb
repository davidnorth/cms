class Public::BaseController < ApplicationController
  include AuthenticatedSystem

  layout 'public'
  helper :all

end
