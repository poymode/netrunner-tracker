class User < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :email, :first_name, :last_name, :userid, :octgnid
  attr_accessible :password, :password_confirmation, :admin, :comments

  has_many :games_as_runner, :class_name => 'Game', :foreign_key => :runner_user_id
  has_many :games_as_corporation, :class_name => 'Game', :foreign_key => :corporation_user_id
  has_many :leagues_created, :class_name => 'League', :foreign_key => :created_by

  has_secure_password

  friendly_id :userid

  ## Constants

  # Maximum number of leagues a user may create
  LEAGUES_CREATE_MAXIMUM = 3

  ## Validations

  validates :userid,
    :uniqueness => true,
    :length     => {
      :minimum => 2,
      :maximum => 16
    }

  validates :email,
    :uniqueness => true,
    :length     => {
      :minimum => 5,
      :maximum => 32
    }

  validates :password,
    :presence => true,
    :length   => {
      :minimum  => 6,
      :maximum  => 32
    }

  validates :first_name,
    :allow_blank => true,
    :length => { :maximum => 32 }

  validates :last_name,
    :allow_blank => true,
    :length => { :maximum => 32 }

  ## Pagination

  paginates_per 10

  ## Handy Methods

  def games
    games_as_runner + games_as_corporation
  end

  def total_games
    games.count
  end

  def overall_average_score
    if games.count > 0
      (games_as_runner.sum(:runner_score).to_f + games_as_corporation.sum(:corporation_score).to_f) / games.count
    else
      0
    end
  end

  def games_as_haas_bioroid
    corp = Corporation.where(:faction => "Haas-Bioroid")
    games_as_corporation.where(:corporation_id => corp)
  end

  def total_games_as_haas_bioroid
    games_as_haas_bioroid.count
  end

  def average_score_as_haas_bioroid
    games_as_haas_bioroid.average(:corporation_score).to_f
  end

  def games_as_jinteki
    corp = Corporation.where(:faction => "Jinteki")
    games_as_corporation.where(:corporation_id => corp)
  end

  def average_score_as_jinteki
    games_as_jinteki.average(:corporation_score).to_f
  end

  def total_games_as_jinteki
    games_as_jinteki.count
  end

  def games_as_nbn
    corp = Corporation.where(:faction => "NBN")
    games_as_corporation.where(:corporation_id => corp)
  end

  def average_score_as_nbn
    games_as_nbn.average(:corporation_score).to_f
  end

  def total_games_as_nbn
    games_as_nbn.count
  end

  def games_as_weyland
    corp = Corporation.where(:faction => "Weyland Consortium")
    games_as_corporation.where(:corporation_id => corp)
  end

  alias games_as_weyland_consortium games_as_weyland

  def total_games_as_weyland
    games_as_weyland.count
  end

  alias total_games_as_weyland_consortium total_games_as_weyland

  def average_score_as_weyland
    games_as_weyland.average(:corporation_score).to_f
  end

  alias average_score_as_weyland_consortium total_games_as_weyland

  def games_as_anarch
    runner = Runner.where(:faction => "Anarch")
    games_as_runner.where(:runner_id => runner)
  end

  def total_games_as_anarch
    games_as_anarch.count
  end

  def average_score_as_anarch
    games_as_anarch.average(:runner_score).to_f
  end

  def average_score_as_criminal
    games_as_criminal.average(:runner_score).to_f
  end

  def average_score_as_shaper
    games_as_shaper.average(:runner_score).to_f
  end

  def games_as_criminal
    runner = Runner.where(:faction => "Criminal")
    games_as_runner.where(:runner_id => runner)
  end

  def total_games_as_criminal
    games_as_criminal.count
  end

  def games_as_shaper
    runner = Runner.where(:faction => "Shaper")
    games_as_runner.where(:runner_id => runner)
  end

  def total_games_as_shaper
    games_as_shaper.count
  end

  def wins_as_runner
    games_as_runner.where(%Q{
      flatlined = ? and (
        runner_score > corporation_score or
        draw_death = ?
      )
    }, false, true)
  end

  def wins_as_anarch
    runner = Runner.where(:faction => "Anarch")
    wins_as_runner.where(:runner_id => runner)
  end

  def total_wins_as_anarch
    wins_as_anarch.count
  end

  def losses_as_anarch
    runner = Runner.where(:faction => "Anarch")
    losses_as_runner.where(:runner_id => runner)
  end

  def total_losses_as_anarch
    losses_as_anarch.count
  end

  def wins_as_criminal
    runner = Runner.where(:faction => "Criminal")
    wins_as_runner.where(:runner_id => runner)
  end

  def total_wins_as_criminal
    wins_as_criminal.count
  end

  def losses_as_criminal
    runner = Runner.where(:faction => "Criminal")
    losses_as_runner.where(:runner_id => runner)
  end

  def total_losses_as_criminal
    losses_as_criminal.count
  end

  def wins_as_shaper
    runner = Runner.where(:faction => "Shaper")
    wins_as_runner.where(:runner_id => runner)
  end

  def total_wins_as_shaper
    wins_as_shaper.count
  end

  def losses_as_shaper
    runner = Runner.where(:faction => "Shaper")
    losses_as_runner.where(:runner_id => runner)
  end

  def total_losses_as_shaper
    losses_as_shaper.count
  end

  def losses_as_runner
    games_as_runner.where(
      %Q{
        draw_death = ? and
        (flatlined = ? or runner_score < corporation_score)
      },
      false, true
    )
  end

  def wins_as_corporation
    games_as_corporation.where(
      %Q{
        draw_death = ? and
        (corporation_score > runner_score or flatlined = ?)
      },
      false, true
    )
  end

  def wins_as_haas_bioroid
    corp = Corporation.where(:faction => "Haas-Bioroid")
    wins_as_corporation.where(:corporation_id => corp)
  end

  def total_wins_as_haas_bioroid
    wins_as_haas_bioroid.count
  end

  def losses_as_haas_bioroid
    corp = Corporation.where(:faction => "Haas-Bioroid")
    losses_as_corporation.where(:corporation_id => corp)
  end

  def total_losses_as_haas_bioroid
    losses_as_haas_bioroid.count
  end

  def wins_as_jinteki
    corp = Corporation.where(:faction => "Jinteki")
    wins_as_corporation.where(:corporation_id => corp)
  end

  def total_wins_as_jinteki
    wins_as_jinteki.count
  end

  def losses_as_jinteki
    corp = Corporation.where(:faction => "Jinteki")
    losses_as_corporation.where(:corporation_id => corp)
  end

  def total_losses_as_jinteki
    losses_as_jinteki.count
  end

  def wins_as_nbn
    corp = Corporation.where(:faction => "NBN")
    wins_as_corporation.where(:corporation_id => corp)
  end

  def total_wins_as_nbn
    wins_as_nbn.count
  end

  def losses_as_nbn
    corp = Corporation.where(:faction => "NBN")
    losses_as_corporation.where(:corporation_id => corp)
  end

  def total_losses_as_nbn
    losses_as_nbn.count
  end

  def wins_as_weyland
    corp = Corporation.where(:faction => "Weyland Consortium")
    wins_as_corporation.where(:corporation_id => corp)
  end

  alias wins_as_weyland_consortium wins_as_weyland

  def total_wins_as_weyland
    wins_as_weyland.count
  end

  alias total_wins_as_weyland_consortium total_wins_as_weyland

  def losses_as_weyland
    corp = Corporation.where(:faction => "Weyland Consortium")
    losses_as_corporation.where(:corporation_id => corp)
  end

  alias losses_as_weyland_consortium losses_as_weyland

  def total_losses_as_weyland
    losses_as_weyland.count
  end

  alias total_losses_as_weyland_consortium total_losses_as_weyland

  def losses_as_corporation
    games_as_corporation.where(
      %Q{
        flatlined = ? and
        (draw_death = ? or corporation_score < runner_score)
      },
      false, true
    )
  end

  def total_wins_as_runner
    wins_as_runner.count
  end

  def total_losses_as_runner
    losses_as_runner.count
  end

  def total_wins_as_corporation
    wins_as_corporation.count
  end

  def total_losses_as_corporation
    losses_as_corporation.count
  end

  def total_wins
    total_wins_as_runner + total_wins_as_corporation
  end

  def total_losses
    total_losses_as_runner + total_losses_as_corporation
  end

  def win_percentage
    (total_wins.to_f / total_games.to_f) * 100
  end

  def total_leagues_created
    leagues_created.count
  end

  def maximum_leagues_created?
    total_leagues_created >= LEAGUES_CREATE_MAXIMUM
  end
end
