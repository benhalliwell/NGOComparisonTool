class ScotlandsController < ApplicationController
  before_action :set_scotland, only: [:show, :edit, :update, :destroy]
  layout 'application'

  helper_method :exists_in_cookie


  # GET /scotlands
  #Methods available on Scotland index page
  def index
    #Find all charities in Scotland
    @scotlands = Scotland.all
    #Filter all charities in Scotland
    @filterrific = initialize_filterrific(Scotland, params[:filterrific]) or return
    @filtered = @filterrific.find.page(params[:scotlands])
    @scotlands = @filtered

    # Store all the ID's in a session so that they can be compared in bulk
    if !session[:sc_all_ids]
      session[:sc_all_ids] ||= []
    else
      session.delete(:sc_all_ids)
    end
      session[:sc_all_ids] ||= []

    #Split all charities into pages
    @filtered.paginate(page: params[:page], per_page: 1000).each do |s|
      session[:sc_all_ids] << s.charity_number
    end

    #Split all charities into pages
    @scotlands = @scotlands.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html
      format.js
      format.csv {
          send_data @filtered.paginate(page: params[:page], per_page: 1000).to_csv
        }
    end

    if !session[:scotsids]
      session[:scotsids] ||= []
    end
    #Methods to see the compare queue, adding and removing cookies
    @compareQueue = session[:scotsids]
    @addcookie = scotland_cookie_path
    @rmcookie = scotland_cookie_remove_path
  end

  #Methods available in comparison
  def comparison
    #Finds all charities selected for comparison
    @compare = Scotland.where(charity_number: session[:scotsids])
    operate=[]
    address=[]
    #Find addresses of all charities being compared
    @compare.each do |a|
      address.push(a.principal_office_trustees_address)
    end
    #Find operating locations of charities being compared
    @compare.each do |b|
      address1 = b.main_operating_location
      operate.push(address1)
    end
    @address = address
    @operate = operate
    #Allows downloading of charities being compared
    @download = Scotland.where(charity_number: session[:scotsids])
    respond_to do |format|
      format.html
      format.js
      format.csv {
        send_data @download.paginate(page: params[:page], per_page: 1000).to_csv
      }
    end
  end

  def cookie
    session[:scotsids] ||= []
  end

  #Allows adding of a cookie
  def add_to_cookie
    id = params[:id]
    if session[:scotsids].include? id
      return "error"
    else
      cookie << id
    end
  end

  #Allows deleting of a cookie
  def delete_cookie
    session.delete(:scotsids)
    redirect_to scotsfilter_path
  end

  #Allows removal of an id from a cookie
  def remove_from_cookie
    id = params[:id]
    if exists_in_cookie(id)
      cookie.delete(id)
    end
  end

  #Check if an id exists in a cookie
  def exists_in_cookie(x)
    if session[:scotsids].include? x
      return true
    else
      return false
    end
  end

  #Adds all ids to a cookie and redirects to the compare page
  def compare_all
    session[:sc_all_ids].each do |s|
      if session[:scotsids].include? s
      else
        cookie << s
      end
    end
    redirect_to scotscompare_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scotland
      @scotland = Scotland.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def scotland_params
      params.require(:scotland).permit(:charity_number, :charity_name, :registered_date, :known_as, :charity_status, :postcode,:constitutional_form, :previous_constitutional_form_1, :geographical_spread, :main_operating_location, :purposes, :beneficiaries, :activities, :objectives, :principal_office_trustees_address, :website, :most_recent_year_income, :most_recent_year_expenditure, :mailing_cycle, :year_end, :parent_charity_name, :parent_charity_number, :parent_charity_country_of_registration, :designated_religious_body, :regulatory_type,{ :postcode_attributes => [:postcode_d, :max_range]},{ :main_operating_location_attributes => [:main, :max_range]})
    end
end
