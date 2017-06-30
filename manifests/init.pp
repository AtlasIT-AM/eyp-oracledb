class oracledb(
                $memory_target                = '1G',
                $manage_ntp                   = true,
                $manage_grub                  = true,
                $manage_tmpfs                 = true,
                $ntp_servers                  = undef,
                $preinstalltasks              = true,
                $createoracleusers            = true,
                $griduser                     = true,
                $preinstallchecks             = true,
                $add_stage                    = true,
                $fs_file_max                  = '6815744',
                $net_ipv4_ip_local_port_range = "9000\t65500",
                $kernel_sem                   = "250\t32000\t100\t128",
                $kernel_shmmni                = '4096',
                $kernel_shmall                = undef,
                $kernel_shmmax                = undef,
              ) inherits oracledb::params {

  if($add_stage)
  {
    stage { 'eyp-oracle-db': }

    Stage['main'] -> Stage['eyp-oracle-db']

    Class['::oracledb::users'] {
      stage => 'eyp-oracle-db',
    }
  }

  class { '::oracledb::users':
    griduser          => $griduser,
    createoracleusers => $createoracleusers,
  }

  ->

  class { 'oracledb::preinstalltasks':
    enabled       => $preinstalltasks,
    memory_target => $memory_target,
    manage_ntp    => $manage_ntp,
    manage_grub   => $manage_grub,
    manage_tmpfs  => $manage_tmpfs,
    ntp_servers   => $ntp_servers,
  }

  if($preinstallchecks)
  {
    class { 'oracledb::preinstallchecks':
      require => Class['oracledb::preinstalltasks'],
    }
  }



}
