Factory.define :valid_user , :class => User do |u|
  u.email "davidnorth@gmail.com"
  u.password "123456"
  u.password_confirmation "123456"
  u.single_access_token "k3cFzLIQnZ4MHRmJvJzg"
end

Factory.define :invalid_user , :class => User do |u|
end

Factory.define :admin_user , :class => User do |u|
  u.email "davidnorth@gmail.com"
  u.password "123456"
  u.admin true
  u.password_confirmation "123456"
  u.single_access_token "k3cFzLIQnZ4MHRmJvJzg"
end
