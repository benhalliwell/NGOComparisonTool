class EnglandNewsController < ApplicationController
  before_action :set_england_news, only: [:show, :edit, :update, :destroy]
  layout 'application'

  helper_method :exists_in_cookie

  # GET /england_news
  #Methods available on the index page
  def index
    #Finds the all English charities
    @england_news = EnglandNew.all

    #Return all filtered results
    @filterrific = initialize_filterrific(EnglandNew, params[:filterrific]) or return
    @filtered = @filterrific.find.page(params[:england_news])
    @england_news = @filtered

    # Store all the ID's in a session so that they can be compared in bulk
    if !session[:eng_all_ids]
      session[:eng_all_ids] ||= []
    else
      session.delete(:eng_all_ids)
    end
      session[:eng_all_ids] ||= []

    #Sort the filtered list into pages
    @filtered.paginate(page: params[:page], per_page: 1000).each do |s|
      session[:eng_all_ids] << s.id
    end
    #Sort the filtered list into pages
    @england_news = @england_news.paginate(page: params[:page], per_page: 20)

    #Allows the downloading of the filtered list
    respond_to do |format|
      format.html
      format.js
      format.csv  {
          send_data @filtered.paginate(page: params[:page], per_page: 1000).to_csv
        }
    end

    if !session[:engids]
      session[:engids] ||= []
    end
    #Finds the ids currently in the comparison queue
    @compareQueue = session[:engids]
    #Adding and removing cookies
    @addcookie = england_cookie_path
    @rmcookie = england_cookie_remove_path
  end


  def cookie
    session[:engids] ||= []
  end

  #Allows the adding of cookies
  def add_to_cookie
    id = params[:id]
    if session[:engids].include? id
      return "error"
    else
      cookie << id
    end
  end

  #Allows deleteing of cookies
  def delete_cookie
    session.delete(:engids)
    redirect_to engfilter_path
  end

  #Allows removal of an id from a cookie
  def remove_from_cookie
    id = params[:id]
    if exists_in_cookie(id)
      cookie.delete(id)
    end
  end

  #id existence check in a cookie
  def exists_in_cookie(x)
    if session[:engids].include? x
      return true
    else
      return false
    end
  end

  #Adds all ids to a cookie and redirects to the compare page
  def compare_all
    session[:eng_all_ids].each do |s|
      if session[:engids].include? s
      else
        cookie << s
      end
    end
    redirect_to engcompare_path
  end

  # GET /england_news/1
  #Methods available on the English profile pages
  def show
    #Finds the charity that has been clicked on
    @england_new= EnglandNew.find(params[:id])
    #Puts the charity address in the format gmaps can work with
    @extract_address = @england_new.add1 + ", " + @england_new.postcode
    #Finds all of the financial data records for a given charity
    @extract_income = EnglandNew.where(regno: @england_new.regno).find_each
  end

  #Methods available on the English comparison page
  def comparison
    #Finds all details of charities selected for comparison
    @compare = EnglandNew.find(session[:engids])
    address=[]
    financials = []
    expend=[]
    income = []
    #Finds addresses of all charities selected for comparison
    @compare.each do |a|
      address.push(a.add1 + ", " + a.postcode)
    end
    #Finds financial information from 2015 for all charities selected for comparison
    @compare.each do |a|
      financials.push(EnglandNew.where('regno = ? AND fystart LIKE ?', a.regno, '2015%').find_each)
    end
    #Push all expenditure information to an array
    financials.each do |a|
      a.each do |b|
        expend.push([b.name, b.expend])
      end
    end
    #Push all income information to an array
    financials.each do |a|
      a.each do |b|
        income.push([b.name, b.income])
      end
    end
    @expend=expend
    @income=income
    @financials = financials
    @address = address

    #Allows the downloading of charity information selected for comparison
    @download = EnglandNew.where(id: session[:engids])
      respond_to do |format|
        format.html
        format.js
        format.csv {
          send_data @download.to_csv
        }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_england_news
      @england_news = EnglandNew.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def england_news_params
      params.require(:england_news).permit(:charity_id, :regno, :subno, :name, :orgtype, :gd, :aob, :nhs, :ha_no, :corr, :add1, :add2, :add3, :add4, :add5, :postcode, :phone, :fax, :created_at, :updated_at, :fystart, :fyend, :income, :expend)
    end
end
