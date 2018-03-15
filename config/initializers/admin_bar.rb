require 'admin_bar'
require 'admin_bar/railtie'
require 'admin_bar/views/view'
require 'admin_bar/views/git'
require 'admin_bar/views/pg'

AdminBar.add AdminBar::Views::Git, short: true
AdminBar.add AdminBar::Views::PG
