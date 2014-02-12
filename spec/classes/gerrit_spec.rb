require 'spec_helper'

describe 'gerrit' do
  let :facts do
    {
      :concat_basedir         => '/nonexistant',
      :operatingsystemrelease => '6.5',
      :osfamily               => 'RedHat',
    }
  end

  it { should contain_class('gerrit') }
end
