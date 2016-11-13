require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareVirtualPortgroup < Inspec.resource(1)
  name 'virtual_portgroup'

  desc "
    This resources reads the switch configuration of a hostsystem.
  "

  example "
    describe virtual_portgroup({datacenter: 'ha-datacenter', host: 'localhost', portgroup: 'VM Network'}) do
      its('vlanId') { should_not eq 1 }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts;
  end

  # Expose all parameters
  def method_missing(name)
    return vlanId[name.to_s]
  end

  def vlanId
    host = get_host(@opts[:datacenter], @opts[:host])
    unless host.nil?
      pgroups = host.config.network.portgroup
      pgroups.each do |group|
        if group.key.include?(@opts[:portgroup])
          return group.spec.vlanId
        end
      end
    end
  end

  def get_host(dc_name, host_name)
    begin
      # TODO: this should something like `inspec.vsphere.connection`
      vim = VSphere.new.connection
      dc = vim.serviceInstance.find_datacenter(dc_name)
      hosts = dc.hostFolder.children
      hosts.each do |entity|
        entity.host.each do |host|
          if host.name == host_name && host.class == RbVmomi::VIM::HostSystem
            return host
          end
        end
      end
    rescue Exception => e
      # TODO: proper logging
      puts e.message
      puts e.backtrace.inspect
      nil
    end
  end
end
