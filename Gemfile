source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'puppet',  puppetversion
gem 'puppet-lint'
gem 'puppetlabs_spec_helper', '>=0.2.0'
