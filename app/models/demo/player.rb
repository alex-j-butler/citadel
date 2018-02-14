class Demo
  class Player < ApplicationRecord
    belongs_to :demo
    belongs_to :user, optional: true

    enum team: [:blu, :red]
    enum player_class: [:scout, :soldier, :pyro, :demoman, :heavy, :engineer, :medic, :sniper, :spy]
  end
end
