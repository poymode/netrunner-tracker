# Seed data.
users = User.create([
  {
    :userid => 'poysama', :email => 'meeplelicious@gmail.com',
    :first_name => 'Jan', :last_name => 'Mendoza', :password => 'menmen1', :admin => true
  },
  {
    :userid => 'test', :email => 'test@bar.com',
    :first_name => 'Test', :last_name => 'Jones', :password => 'asdfasdf'
  },
])

leagues = League.create([
  {:name => 'Dark Matter', :comments => 'Dark Matter Games',    :created_by => User.first},
  {:name => 'OCTGN',       :comments => 'Online meetup group',  :created_by => User.first},
  {:name => 'Test',        :comments => 'Test group',           :created_by => User.last}
])

runners = Runner.create([
  {:faction => 'Criminal',  :identity => 'Cyborg',  :name => 'Gabriel Santiago'},
  {:faction => 'Shaper',    :identity => 'Natural', :name => "Kate 'Mac' McCaffrey"},
  {:faction => 'Anarchist', :identity => 'G-mod',   :name => 'Noise'}
])

corporations = Corporation.create([
  {:faction => 'Haas-Bioroid',       :slogan => 'Engineering the Future',  :identity => 'Megacorp'},
  {:faction => 'Weyland Consortium', :slogan => 'Building a Better World', :identity => 'Megacorp'},
  {:faction => 'Jinteki',            :slogan => 'Replicating Perfection',  :identity => 'Megacorp'},
  {:faction => 'NBN',                :slogan => 'Making News',             :identity => 'Megacorp'},
])
