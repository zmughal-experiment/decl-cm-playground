apt_update 'update'

package 'apache2' do
  action :install
end
