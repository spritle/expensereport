class LoginController < ApplicationController

  before_filter :authorize, :except => :login
  layout 'application'
  def list
    @title = "Expense Calculator"
    @bills = Bill.find(:all)
    @items = Item.find(:all)
  end
  def create
    @title = "Expense Calculator"
    @bills = Bill.new(params[:bill])    
    @bills.date = Time.now.strftime("%d-%B-%y")    
    @bills.user_name = session[:user_name]
    @bills.month_year = Time.now.strftime("%B") + "-" + Time.now.strftime("%y")
    if @bills.save
      render :partial => 'bill', :object => @items
    end
  end
  def item
    @title = "Expense Calculator"
    @items = Item.find(:all)
    #itemcode = params[:item][:item_code]
  end
  def edit

  end
  def index
    @title = "Expense Calculator"
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end
    @user_name = session[:user_name]
    @bills = Bill.find(:all,:select => 'month_year, sum(amount) as amount', :conditions => "user_name = '#{@user_name}'",:group => "month_year")
  end

  def login
    @title = "Log in to Expense Calculator"
    if request.post? and params[:user]
      @user = User.new(params[:user])
      user = User.find_by_user_name_and_password(@user.user_name,@user.password)
      if user
        session[:user_id] = user.id
        session[:user_name] = user.user_name
        #flash[:notice] = "User #{user.user_name} logged in!"
        redirect_to :action => "index"
      else
        # Don't show the password in the view.
        @user.password = nil
        flash[:notice] = "Invalid user name/password combination"
      end
    end
  end

  def logout
    @title = "Expense Calculator"    
    session[:user_id] = nil
    flash[:notice] = "User " + session[:user_name] + " Logged out"
    
  end

  def update
#    if Bill.update({ :description => 'Samuel', :item_code => 123 })
#      render :partial => 'bill', :object => @items
#    else
#      redirect_to :action => 'login'
#    end
  end

  def destroy
    @bill = Bill.find(params[:id])
    if @bill.destroy
      redirect_to :action => 'list'      
    end
  end

  def view
    @title = "Expense Calculator"
    @bills = Bill.find(:all, :conditions => "month_year = '#{params[:month_year]}'AND user_name = '#{session[:user_name]}'")
  end

  def save
    file = "#{session[:user_name]}_#{Time.now.strftime('%a-%b-%y-%I-%M-%S-%p')}_Bill.xls"
    workbook= Spreadsheet::Excel.new(  "#{RAILS_ROOT}/#{file}" )
    f1 = Format.new(
      :size => 10,      
      :fg_color => "yellow"
    )
    f2 = Format.new(
      :color  => "purple",
      :bold   => 1,
      :size => 20,
      :text_wrap => 1,
      :top => 0
    )
    f3 = Format.new(
      :fg_color => "cyan"
    )
    workbook.add_format(f1)
    workbook.add_format(f2)
    workbook.add_format(f3)
    worksheet = workbook.add_worksheet("Business Expense Report")
    worksheet.write(0,2,"Spritle BV",f2)
    worksheet.write(2,2,"BUSINESS EXPENSE REPORT")
    worksheet.write(4,2,"Employee Name")
    worksheet.write(4,3,"#{session[:user_name].capitalize}",f1)
    worksheet.write(10,0, "Item",f3)
    worksheet.write(10,1,"Date",f3)
    worksheet.write(10,2, "Description",f3)
    worksheet.write(10,3,"Item_code",f3)
    worksheet.write(10,4, "curr",f3)
    worksheet.write(10,5,"Amount",f3)
    worksheet.write(10,6, "Rate",f3)
    worksheet.write(10,7,"Amount_INR",f3)

    @bills = Bill.find(:all)
    row =12
    @bills.each do |bill|
      worksheet.write(row, 0, "#{bill.id}",f1)
      worksheet.write(row, 1, "#{bill.date.strftime('%d %b %y')}",f1)
      worksheet.write(row, 2, "#{bill.description}",f1)
      worksheet.write(row, 3, "#{bill.item_code}",f1)
      worksheet.write(row, 4, "#{bill.curr}",f1)
      worksheet.write(row, 5, "#{bill.amount}",f1)
      worksheet.write(row, 6, "#{bill.rate}",f3)
      worksheet.write(row, 7, "#{bill.amount_inr}",f3)
      row += 1
    end
    workbook.close

  end
end

