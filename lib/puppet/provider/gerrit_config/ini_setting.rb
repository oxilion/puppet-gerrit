Puppet::Type.type(:gerrit_config).provide(
  :ini_setting,
  # set ini_setting as the parent provider
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do
  # implement section as the first part of the namevar
  def section
    resource[:name].split('/', 2).first
  end
  def setting
    # implement setting as the second part of the namevar
    resource[:name].split('/', 2).last
  end
end
