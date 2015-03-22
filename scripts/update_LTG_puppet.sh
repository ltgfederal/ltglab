echo "Cloning repositories"
git clone https://github.com/ibravo/astapor.git
git clone https://github.com/ibravo/ltgcloud.git
git clone https://github.com/ibravo/puppet-ceph.git

echo "Copying from repo to foreman directory"
\cp -a ./astapor/puppet/modules/* /etc/puppet/environments/production/modules/
\cp -a ./ltgcloud/modules/* /etc/puppet/environments/production/modules/
\cp -a ./puppet-ceph/manifests/* /etc/puppet/environments/production/modules/puppet-ceph/

echo "removing temp files"
rm -rf astapor
rm -rf ltgcloud
rm -rf puppet-ceph

echo "Now you should refresh the available modules in formena or use Hammer to do so"



