class TimeRecordsController < ApplicationController
  
  before_action :authorize
  
  def index
    if User.find_by(id: session[:user_id]).admin?
      @timerecords = TimeRecord.all.paginate(:page => params[:page]).order(:date)
    else
      @timerecords = TimeRecord.where("user_id = ?", User.find_by(id: session[:user_id])).paginate(:page => params[:page]).order(:date) 
    end
    
  end 

  def show
    @timerecord = TimeRecord.find(params[:id])
  end  
  
  def new 
    @timerecord = TimeRecord.new
    @user_name = current_user.name
    @pay_periods = PayPeriod.pluck(:date)
  end
  
  def edit
    @timerecord = TimeRecord.find(params[:id])
    @pay_periods = PayPeriod.pluck(:date)
  end  
  
  def create
    @timerecord = current_user.time_records.build(timerecord_params)
    respond_to do |format|
      if @timerecord.save
        format.html { redirect_to time_records_url, notice: 'Transaction was successfully created.' }
        format.json { redirect_to time_records_url, status: :created, location: @timerecord }
      else
        format.html { render :new }
        format.json { render json: @timerecord.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    @timerecord = TimeRecord.find(params[:id])
    respond_to do |format|
      if @timerecord.update(timerecord_params)
        format.html { redirect_to time_records_url, notice: 'Time Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @timerecord }
      else
        format.html { render :edit }
        format.json { render json: @timerecord.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @timerecord = TimeRecord.find(params[:id])  
    @timerecord.destroy
    respond_to do |format|
      format.html { redirect_to time_records_url, notice: 'Time Record was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  
    def timerecord_params
      params.require(:time_record).permit(:user_id, :hours, :vacation, :sick, :date)
    end
end
