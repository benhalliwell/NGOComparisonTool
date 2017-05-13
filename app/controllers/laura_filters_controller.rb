class LauraFiltersController < ApplicationController
  before_action :set_laura_filter, only: [:show, :edit, :update, :destroy]

  # GET /laura_filters
  def index
    @laura_filters = LauraFilter.all
    @laura_filters = @laura_filters.paginate(page: params[:page], per_page: 20)
  end

  # GET /laura_filters/1
  def show
  end

  # GET /laura_filters/new
  def new
    @laura_filter = LauraFilter.new
  end

  # GET /laura_filters/1/edit
  def edit
  end

  # POST /laura_filters
  def create
    @laura_filter = LauraFilter.new(laura_filter_params)

    if @laura_filter.save
      redirect_to @laura_filter, notice: 'Laura filter was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /laura_filters/1
  def update
    if @laura_filter.update(laura_filter_params)
      redirect_to @laura_filter, notice: 'Laura filter was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /laura_filters/1
  def destroy
    @laura_filter.destroy
    redirect_to laura_filters_url, notice: 'Laura filter was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laura_filter
      @laura_filter = LauraFilter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def laura_filter_params
      params.require(:laura_filter).permit(:charity_number, :subno, :name)
    end
end
