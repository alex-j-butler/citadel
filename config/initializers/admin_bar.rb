require 'admin_bar'
require 'admin_bar/railtie'
require 'admin_bar/views/view'
require 'admin_bar/views/git'
require 'admin_bar/views/pg'
require 'admin_bar/views/delayed_job'

AdminBar.add AdminBar::Views::Git, short: true
AdminBar.add AdminBar::Views::PG
AdminBar.add AdminBar::Views::DelayedJob
