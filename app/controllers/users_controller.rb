class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    if params[:league_id]
      @league = League.find(params[:league_id])
      @users  = User.where(:id => @league.users)
    elsif params[:game_id]
      @game  = Game.find(params[:game_id])
      @users = User.where(:id => @game.players)
    elsif params[:tournament_id]
      @tournament = Tournament.find(params[:tournament_id])
      @users = Kaminari.paginate_array(@tournament.players)
    elsif params[:match_id]
      @match = Match.find(params[:match_id])
      @users = Kaminari.paginate_array(@match.players)
    else
      @users = User.order("lower(userid)")
    end

    @users = @users.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    unless @user
      flash[:error] = "Player not found."
      redirect_to users_path
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @current = User.find(session[:user_id])

    unless @user
      flash[:error] = "Player not found."
      redirect_to users_path
      return
    end

    unless @current.admin? || @current == @user
      flash[:error] = "You do not have permission to edit this player!"
      redirect_to user_path(@user)
      return
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @current = User.find(session[:user_id])

    unless @current.admin?
      flash[:error] = "You do not have permission to delete this player!"
      redirect_to user_path(@user)
      return
    end

    unless @user.total_games == 0
      flash[:error] = "You cannot delete a user with at least 1 recorded game."
      redirect_to user_path(@user)
      return
    end

    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def stats
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json
    end
  end
end
