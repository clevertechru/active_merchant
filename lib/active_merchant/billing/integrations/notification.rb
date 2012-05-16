require 'ipaddr'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      class Notification
        attr_accessor :params
        attr_accessor :raw
        
        # set this to an array in the subclass, to specify which IPs are allowed to send requests
        class_attribute :production_ips

        def initialize(post, options = {})
          @options = options
          if @options.has_key?(:production_ips)
            self.production_ips = @options[:production_ips].map {|ip| IPAddr.new(ip)}
          end
          empty!
          if post.is_a?(Hash)
            @params = post.clone
          else
            parse(post)
          end
        end

        # subclasses should implement this method to make parameter-based integration detection work
        def self.recognizes?(params)
          false
        end

        def status
          raise NotImplementedError, "Must implement this method in the subclass"
        end

        # the money amount we received in X.2 decimal.
        def gross
          raise NotImplementedError, "Must implement this method in the subclass"
        end

        def gross_cents
          (gross.to_f * 100.0).round
        end

        def transaction_id
          nil
        end

        # This combines the gross and currency and returns a proper Money object. 
        # this requires the money library located at http://dist.leetsoft.com/api/money
        def amount
          return Money.new(gross_cents, currency) rescue ArgumentError
          return Money.new(gross_cents) # maybe you have an own money object which doesn't take a currency?
        end

        # reset the notification. 
        def empty!
          @params  = Hash.new
          @raw     = ""      
        end
        
        # Check if the request comes from an official IP
        def valid_sender?(ip)
          return true if ActiveMerchant::Billing::Base.integration_mode == :test || production_ips.blank?
          ip = IPAddr.new(ip) if ip.is_a?(String)
          production_ips.each do |net|
            return net.include?(ip)
          end
        end

        def response_content_type
          'text/html'
        end
        
        def success_response(*args)
          "OK"
        end
        
        def error_response(*args)
          "ERROR"
        end

        private

        # Take the posted data and move the relevant data into a hash
        def parse(post)
          @raw = post.to_s
          for line in @raw.split('&')    
            key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
            params[key] = CGI.unescape(value)
          end
        end
      end
    end
  end
end
