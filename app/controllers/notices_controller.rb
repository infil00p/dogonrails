class NoticesController < ApplicationController
  uses_tiny_mce
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    page = params[:page]
    if page.nil?
      page = 1
    end
    @notices = Notice.list(page)
    
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(params[:notice])
    unless params[:access_node] == 'all'
      @notice.access_node = AccessNode.find(parmas[:access_node])
    end
    @notice.user = session[:user]
    if @notice.save
      flash[:notice] = 'Notice was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = session[:user]
    @notice = Notice.find(params[:id])
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update_attributes(params[:notice])
      flash[:notice] = 'Notice was successfully updated.'
      redirect_to :action => 'show', :id => @notice
    else
      render :action => 'edit'
    end
  end

  def destroy
    Notice.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
