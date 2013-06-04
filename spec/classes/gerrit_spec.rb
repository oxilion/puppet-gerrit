require 'spec_helper'

describe 'gerrit' do
  let :facts do
    {
      :osfamily                 => 'RedHat',
      :postgres_default_version => '8.4',
    }
  end

  it { should include_class('gerrit') }
end
