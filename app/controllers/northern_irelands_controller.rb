class NorthernIrelandsController < ApplicationController
  before_action :set_northern_ireland, only: [:show, :edit, :update, :destroy]

  helper_method :exists_in_cookie

  # GET /northern_irelands
  #Methods available on the NI index page
  def index
    #Find all charities in NI
    @northern_irelands = NorthernIreland.all
    #Filter charities in NI
    @filterrific = initialize_filterrific(NorthernIreland, params[:filterrific]) or return
     @filtered = @filterrific.find.page(params[:northern_irelands])
    @northern_irelands = @filtered

    # Store all the ID's in a session so that they can be compared in bulk
    if !session[:ni_all_ids]
      session[:ni_all_ids] ||= []
    else
      session.delete(:ni_all_ids)
    end

    session[:ni_all_ids] ||= []

    #Split the filtered NI information into pages
    @filtered.paginate(page: params[:page], per_page: 1000).each do |s|
      session[:ni_all_ids] << s.reg_charity_number
    end
    @northern_irelands = @northern_irelands.paginate(page: params[:page], per_page: 20)

    #Allow the downloading of NI information
    respond_to do |format|
      format.html
      format.js
      format.csv {
          send_data @filtered.paginate(page: params[:page], per_page: 1000).to_csv
        }
    end

    if !session[:irelandids]
      session[:irelandids] ||= []
    end
    #Methods to access compare queue, add a cookie or remove a cookie
    @compareQueue = session[:irelandids]
    @addcookie = ireland_cookie_path
    @rmcookie = ireland_cookie_remove_path
  end

  def comparison
    #Find charities selected for comparison
    @compare = NorthernIreland.where(reg_charity_number: session[:irelandids])
    address=[]
    #Find the addresses of charities selected for comparison
    @compare.each do |a|
      address.push(a.public_address)
    end
    @address = address
    #Allow the downloading of a given profile page
    @download = NorthernIreland.where(reg_charity_number: session[:irelandids])
    respond_to do |format|
      format.html
      format.js
      format.csv {
        send_data @download.paginate(page: params[:page], per_page: 1000).to_csv
      }
    end
  end

  def cookie
    session[:irelandids] ||= []
  end

  #Allow adding of an id to a cookie
  def add_to_cookie
    id = params[:id]
    if session[:irelandids].include? id
      return "error"
    else
      cookie << id
    end
  end

  #Allow deletion of a cookie
  def delete_cookie
    session.delete(:irelandids)
    redirect_to northern_irelandfilter_path
  end

  #Allow removal of an id from a cookie
  def remove_from_cookie
    id = params[:id]
    if exists_in_cookie(id)
      cookie.delete(id)
    end
  end

  #Check if an id exists in a cookie
  def exists_in_cookie(x)
    if session[:irelandids].include? x
      return true
    else
      return false
    end
  end

  #Adds all ids to a cookie and redirects to the compare page
  def compare_all
    session[:ni_all_ids].each do |s|
      if session[:irelandids].include? s
      else
        cookie << s
      end
    end
    redirect_to northern_irelandcompare_path
  end

  # PATCH/PUT /northern_irelands/1
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_northern_ireland
      @northern_ireland = NorthernIreland.find(params[:id])
    end


    # Only allow a trusted parameter "white list" through.
    def northern_ireland_params
      params.require(:northern_ireland).permit(:reg_charity_number, :sub_charity_number, :charity_name, :date_registered, :status, :date_for_financial_year_ending, :total_income, :total_spending, :charitable_spending, :income_generation_and_governance, :public_address, :website, :email, :telephone, :company_number, :what_the_charity_does, :who_the_charity_helps, :how_the_charity_works, {:public_address_attributes =>[:address, :max_range]})
    end
end
