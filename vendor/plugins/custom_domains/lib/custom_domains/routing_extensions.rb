module CustomDomains
  module RouteExtensions
    def self.included(base)
      base.alias_method_chain :recognition_conditions, :subdomain
    end

    def recognition_conditions_with_subdomain
      result = recognition_conditions_without_subdomain
      result << "env[:host] != BASE_DOMAIN" if conditions[:custom_domain] == true
      result << "env[:host] == BASE_DOMAIN" if conditions[:custom_domain] == false
      result
    end
  end

  module RouteSetExtensions
    def self.included(base)
      base.alias_method_chain :extract_request_environment, :subdomain
    end

    def extract_request_environment_with_subdomain(request)
      env = extract_request_environment_without_subdomain(request)
      env.merge(:host => request.host, :domain => request.domain, :subdomain => request.subdomains.first)
    end
  end
end

ActionController::Routing::RouteSet.send(:include, CustomDomains::RouteSetExtensions)
ActionController::Routing::Route.send(:include, CustomDomains::RouteExtensions)