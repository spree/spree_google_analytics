source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'spree_dev_tools', '>= 0.6.0.rc1'
gem 'rails-controller-testing'

spree_opts = if ENV['SPREE_PATH']
                { 'path': ENV['SPREE_PATH'] }
             else
                { 'github': 'spree/spree', 'branch': 'main', 'glob': 'spree/**/*.gemspec' }
             end
gem 'spree', spree_opts
gem 'spree_admin', spree_opts

gem 'spree_posts', { github: 'spree/spree-posts', branch: 'main' }

spree_storefront_opts = { github: 'spree/spree-rails-storefront', branch: 'main', glob: '**/*.gemspec' }
gem 'spree_storefront', spree_storefront_opts
gem 'spree_page_builder', spree_storefront_opts

if ENV['DB'] == 'mysql'
  gem 'mysql2'
elsif ENV['DB'] == 'postgres'
  gem 'pg'
else
  gem 'sqlite3'
end

gem 'propshaft'

gemspec
