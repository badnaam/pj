module GeokitForNamedScopes
  OPTIONS = [:origin, :within, :beyond, :range, :formula, :bounds]

  def find(*args)
    super(*transfer_from_scope_to_args(args))
  end

  def count(*args)
    super(*transfer_from_scope_to_args(args))
  end

  private
    def transfer_from_scope_to_args(args)
      find_options = scope(:find)
      if find_options.is_a?(Hash)
        options = args.extract_options!
        OPTIONS.each do |key|
          options[key] = find_options.delete(key) if find_options.key?(key)
        end
        args << options
      else
        args
      end
    end
end

class ActiveRecord::Base
  class << self
    def acts_as_mappable(*args)
      result = super(*args)
      extend GeokitForNamedScopes

      GeokitForNamedScopes::OPTIONS.each do |key|
        named_scope key, lambda { |value| {key => value} }
      end

      result
    end

    VALID_FIND_OPTIONS += GeokitForNamedScopes::OPTIONS
  end
end
