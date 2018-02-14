class Demo < ApplicationRecord
  has_many :players, class_name: 'Demo::Player'

  mount_uploader :demo, DemoUploader
end
