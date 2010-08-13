module ActiveReload
  # SlaveFilter is an around filter for controllers that require certain actions
  # to use the slave database for all reads when that's not set as the default.
  #
  # Usage:
  #   # class level:
  #   around_filter ActiveReload::SlaveFilter
  #   
  #   # instance level:
  #   around_filter ActiveReload::SlaveFilter.new(MyModel)
  class SlaveFilter
    def self.filter(controller, &block)
      with_slave(&block)
    end
    
    def self.with_slave(klass = ActiveRecord::Base)
      if klass.connection.masochistic?
        klass.connection.with_slave { yield }
      else
        yield
      end
    end
    
    def initialize(klass)
      @klass = klass
    end
    
    def filter(controller, &block)
      self.class.with_slave(@klass, &block)
    end
  end
end