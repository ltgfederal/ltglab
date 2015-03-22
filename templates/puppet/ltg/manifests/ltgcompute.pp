# LTG Compute node configuration using quickstack, and openstack modules.
class ltg::ltgcompute (
  $admin_password         = 'Ic3H0us32014',
  
  $ceilometer             = 'false',
  $cinder_backend_gluster = 'false',
  
  $neutron_db_password    = 'Ic3H0us32014',
  $neutron_user_password  = 'Ic3H0us32014',
  $nova_db_password       = 'Ic3H0us32014',
  $nova_user_password     = 'Ic3H0us32014',
  $amqp_password          = 'Ic3H0us32014',

  $amqp_host              = 'rabbitni101',
  $auth_host              = 'keystadmi100',
  $mysql_host             = 'mysqlci100',

 
) {
  class {'quickstack::neutron::compute':}
  }

