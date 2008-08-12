module ForteDesigns #:nodoc:
  class Location

    attr_reader :options,
    #:country,
    :name,
    :firm_name,
    :zip5,
    :zip4,
    :state,
    :city,
    :address1,
    :address2
    #:phone,
    #:fax,
    #:address_type

    alias_method :postal_code, :zip5
    alias_method :postal, :postal_code
    alias_method :province, :state
    alias_method :territory, :province
    alias_method :region, :province

    def initialize(options = {})
      #@country = (options[:country].nil? or options[:country].is_a?(ActiveMerchant::Country)) ?
      #options[:country] :
      #ActiveMerchant::Country.find(options[:country])
      @name = options[:name]
      @firm_name = options[:firm_name]
      @zip5 = options[:postal_code] || options[:postal] || options[:zip5]
      @zip4 = options[:zip4]
      @state = options[:province] || options[:state]
      @city = options[:city]
      @address1 = options[:address1]
      @address2 = options[:address2]
    end

    def self.from(object, options={})
      return object if object.is_a? ForteDesigns::Location
      attr_mappings = {
        #:country => [:country_code, :country],
        :zip5 => [:postal_code, :zip5, :postal],
        :zip4 => [:zip4],
        :state => [ :province, :state],
        :city => [:city],
        :address1 => [:address1],
        :address2 => [:address2]
      }
      attributes = {}
      hash_access = begin
        object[:some_symbol]
        true
      rescue
        false
      end
      attr_mappings.each do |pair|
        pair[1].each do |sym|
          if value = (object[sym] if hash_access) || (object.send(sym) if object.respond_to?(sym) && (!hash_access || !Hash.public_instance_methods.include?(sym.to_s)))
            attributes[pair[0]] = value
            break
          end
        end
      end
      self.new(attributes.update(options))
    end


    def to_s
      prettyprint.gsub(/\n/, ' ')
    end

    def prettyprint
      chunks = []
      chunks << [@name,@firm_name].reject {|e| e.blank?}.join("\n")
      chunks << [@address1,@address2].reject {|e| e.blank?}.join("\n")
      chunks << [@city,@state,@zip5].reject {|e| e.blank?}.join(', ')
      chunks.reject {|e| e.blank?}.join("\n")
    end

    def inspect
      string = prettyprint
      string
    end
  end

end
