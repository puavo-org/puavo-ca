PuavoCa::Application.routes.draw do
  match 'certificates/rootca(.:format)'        => 'certificates#rootca',        :via => :get,    :format => :text
  match 'certificates/orgcabundle(.:format)'   => 'certificates#orgcabundle',   :via => :get,    :format => :text
  match 'certificates/show_by_fqdn(.:format)'  => 'certificates#show_by_fqdn',  :via => :get,    :format => :json
  match 'certificates/revoke(.:format)'        => 'certificates#revoke',        :via => :delete, :format => :json
  match 'certificates/test_clean_up(.:format)' => 'certificates#test_clean_up', :via => :delete, :format => :json

  resources :certificates, :only => [:create], :format => :json
end
