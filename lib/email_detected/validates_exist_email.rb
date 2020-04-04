# frozen_string_literal: true

if defined?(ActiveSupport)
  ActiveSupport.on_load(:active_record) do
    module EmailDetected
      module ValidatesExistEmail
        module Validator
          require 'mail'

          class EmailExistValidator < ActiveModel::EachValidator
            def validate_each(record, attribute, value)
              begin
                m = Mail::Address.new(value)
                r = !m.domain.nil? && m.domain.match('\.') && m.address == value
                r = EmailDetected.exist? m.address
                r = r[:status]
              rescue StandardError
                r = false
              end
              unless r
                record.errors[attribute] << (options[:message] || 'does not exist')
              end
            end
          end
        end

        module ClassMethods
          def validates_exist_email_of(*attr_names)
            validates_with ActiveRecord::Base::EmailExistValidator, _merge_attributes(attr_names)
          end
        end
      end
    end

    ActiveRecord::Base.include EmailDetected::ValidatesExistEmail::Validator
    ActiveRecord::Base.extend EmailDetected::ValidatesExistEmail::ClassMethods
  end
end
