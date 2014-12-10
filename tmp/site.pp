node 'puppetclient.mib.garr.it' {

  idpfirewall::firewall { "{hostname}-firewall":
    iptables_enable_network => undef,
  }

  $hostfqdn                = 'puppetclient.mib.garr.it'
  $keystorepassword        = '17GK7DCPwNS0RJDX'
  $mailto                  = 'idpcloud-service@garr.it'
  $nagiosserver            = ''

  shib2common::instance { "${hostname}-common":
    install_apache          => true,
    install_tomcat          => true,
    configure_admin         => false,
    tomcat_admin_password   => '',
    tomcat_manager_password => '',
    hostfqdn                => $hostfqdn,
    keystorepassword        => $keystorepassword,
    mailto                  => $mailto,
    nagiosserver            => $nagiosserver,
  }

  shib2idp::instance { "${hostname}-idp":
    metadata_information => {
      
      'en' => {
        'orgDisplayName'           => 'Test IdP in the Cloud Project',
        'communityDesc'            => 'Identity Provider of Test IdP in the Cloud Project',
        'orgUrl'                   => 'http://www.mib.garr.it',
        'privacyPage'              => 'https://puppetclient.mib.garr.it/idp/privacy.html',
        'nameOrg'                  => 'Test IdP in the Cloud Project',
        'idpInfoUrl'               => 'https://puppetclient.mib.garr.it/idp/info.html',
        'url_LogoOrg-32x32'        => 'https://puppetclient.mib.garr.it/idp/images/institutionLogo-32x32_en.png',
        'url_LogoOrg-160x120'      => 'https://puppetclient.mib.garr.it/idp/images/institutionLogo-160x120_en.png',
      },
      
      'it' => {
        'orgDisplayName'           => 'Test IdP in the Cloud Project',
        'communityDesc'            => 'Identity Provider of Test IdP in the Cloud Project',
        'orgUrl'                   => 'http://www.mib.garr.it',
        'privacyPage'              => 'https://puppetclient.mib.garr.it/idp/privacy.html',
        'nameOrg'                  => 'Test IdP in the Cloud Project',
        'idpInfoUrl'               => 'https://puppetclient.mib.garr.it/idp/info.html',
        'url_LogoOrg-32x32'        => 'https://puppetclient.mib.garr.it/idp/images/institutionLogo-32x32_it.png',
        'url_LogoOrg-160x120'      => 'https://puppetclient.mib.garr.it/idp/images/institutionLogo-160x120_it.png',
      },
      
      'technicalEmail'             => 'idpcloud-service@garr.it',
      'technicalIDPadminGivenName' => '',
      'technicalIDPadminSurName'   => '',
      'technicalIDPadminTelephone' => '',
      'registrationInstant'        => '2014-12-09T15:19:30Z',
    },
    shibbolethversion            => undef,
    install_uapprove             => true,
    idpfqdn                      => $hostfqdn,
    keystorepassword             => $keystorepassword,
    mailto                       => $mailto,
    install_ldap                 => true,
    domain_name                  => 'mib.garr.it',
    basedn                       => 'dc=mib,dc=garr,dc=it',
    rootdn                       => 'cn=admin',
    rootpw                       => '17GK7DCPwNS0RJDX',
    rootldappw                   => '17GK7DCPwNS0RJDX',
    ldap_host                    => undef,
    ldap_use_ssl                 => undef,
    ldap_use_tls                 => undef,
    logserver                    => '',
    collectdserver               => '',
    nagiosserver                 => $nagiosserver,
    sambadomain                  => 'IDP-IN-THE-CLOUD',
    test_federation              => true,
    custom_styles                => true,
    first_install                => true,
  }
}