class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.json
  def index
    if params[:tournament_id]
      @tournament = Tournament.find(params[:tournament_id])
      @matches = Match.where(:tournament_id => @tournament)
    else
      @matches = Match.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.json
  def new
    @match = Match.new
    @game1 = Game.new
    @game2 = Game.new

    @users = User.order("lower(userid)")
    @runners = Runner.order(:faction, :name)
    @corporations = Corporation.order(:faction, :slogan)

    @match.games = [@game1, @game2]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
    @game1 = @match.games[0]
    @game2 = @match.games[1]

    @users = User.order("lower(userid)")
    @runners = Runner.order(:faction, :name)
    @corporations = Corporation.order(:faction, :slogan)
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(params[:match])
    @game1 = Game.new(params[:game1])
    @game2 = Game.new(params[:game2])

    @users = User.order("lower(userid)")
    @runners = Runner.all
    @corporations = Corporation.all

    @game1.date = @match.date
    @game2.date = @match.date

    @game1.league_id = params[:match][:league_id]
    @game2.league_id = params[:match][:league_id]

    @match.games = [@game1, @game2]

    # Add this here to make it look nicer on error.
    if @game1.runner_user == @game2.runner_user
      flash.now[:error] = "Runner may not be same player in both games of a match"
    end

    if @game1.runner_user == @game1.corporation_user ||
       @game2.runner_user == @game2.corporation_user
    then
      flash.now[:error] = "Runner and Corporation may not be the same player within a game"
    end

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.json
  def update
    @match = Match.find(params[:id])

    @game1 = @match.games[0]
    @game2 = @match.games[1]

    @users = User.order("lower(userid)")
    @runners = Runner.all
    @corporations = Corporation.all

    # TODO: Get nested model form to work!
    @match.games.first.update_attributes(params[:game1])
    @match.games.last.update_attributes(params[:game2])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end
end
