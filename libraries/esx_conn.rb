class ESXConnection
  def initialize
    # TODO: this does not belong here and should be an InSpec target information
    # can I extend this from InSpec

    require 'rbvmomi'

    # INSPEC_ESX_CONN='vsphere://root:vmwarevmware@192.168.10.139'
    # Windows PowerShell $env:INSPEC_ESX_CONN = 'vsphere://domain\gbright:password@vCenter'
    connection_string = ENV['INSPEC_ESX_CONN']
    if connection_string.nil?
      puts 'Please use vsphere://username:password@host'
      return
    end

    # Need to escape the string for chars that will cause URI::Parser to fail
    connection_string_encoded = URI.encode(connection_string)

    connection = URI(connection_string)
    if connection.scheme != 'vsphere' ||
       connection.host.nil? ||
       connection.password.nil? ||
       connection.user.nil?
      raise 'Please use vsphere://username:password@host'
    end

    @conn_opts = {
      host: connection.host,
      user: URI.decode(connection.user),
      password: URI.decode(connection.password),
      insecure: true,
    }

  def connection
    return @conn if defined?(@conn)
    @conn = RbVmomi::VIM.connect @conn_opts
  rescue RuntimeError
    nil
  end
end
