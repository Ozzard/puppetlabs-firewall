# frozen_string_literal: true

#
# firewall.rb
#
class Puppet::Provider::Firewall < Puppet::Provider
  # Prefetch our rule list. This is ran once every time before any other
  # action (besides initialization of each object).
  def self.prefetch(resources)
    debug('[prefetch(resources)]')
    instances.each do |prov|
      resource = resources[prov.name] || resources[prov.name.downcase]
      if resource
        resource.provider = prov
      end
    end
  end

  # Look up the current status. This allows us to conventiently look up
  # existing status with properties[:foo].
  def properties
    if @property_hash.empty?
      @property_hash = query || { ensure: :absent }
      @property_hash[:ensure] = :absent if @property_hash.empty?
    end
    @property_hash.dup
  end

  # Pull the current state of the list from the full list.  We're
  # getting some double entendre here....
  def query
    self.class.instances.each do |instance|
      if instance.name == name || instance.name.downcase == name
        return instance.properties
      end
    end
    nil
  end
end
