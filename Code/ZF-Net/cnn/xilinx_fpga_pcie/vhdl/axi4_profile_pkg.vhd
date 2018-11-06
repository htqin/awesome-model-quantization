--
-- AXI4-MM Profile Definitions
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.axi4_field.all;

package axi4_profile is

  --
  -- SUBCHANNELS
  --
  
  type axi4_ar_m2s_t is record
    addr    : axi4_addr64_t;
    burst   : axi4_burst_t;
    cache   : axi4_cache_t;
    id      : axi4_id8_t;
    len     : axi4_len8_t;
    lock    : axi4_lock_t;
    prot    : axi4_prot_t;
    qos     : axi4_qos_t;
    region  : axi4_region_t;
    size    : axi4_size_t;
    valid   : std_logic;
  end record;
  constant axi4_ar_m2s_default : axi4_ar_m2s_t := (
    addr    => (others => '0'),
    burst   => (others => '-'),
    cache   => (others => '-'),
    id      => (others => '0'),
    len     => (others => '-'),
    lock    => (others => '-'),
    prot    => (others => '-'),
    qos     => (others => '-'),
    region  => (others => '-'),
    size    => (others => '-'),
    valid   => '0'
  );
  
  type axi4_ar_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4_ar_s2m_default : axi4_ar_s2m_t := (
    ready   => '0'
  );
  
  type axi4_aw_m2s_t is record
    addr    : axi4_addr64_t;
    burst   : axi4_burst_t;
    cache   : axi4_cache_t;
    id      : axi4_id8_t;
    len     : axi4_len8_t;
    lock    : axi4_lock_t;
    prot    : axi4_prot_t;
    qos     : axi4_qos_t;
    region  : axi4_region_t;
    size    : axi4_size_t;
    valid   : std_logic;
  end record;
  constant axi4_aw_m2s_default : axi4_aw_m2s_t := (
    addr    => (others => '0'),
    burst   => (others => '-'),
    cache   => (others => '-'),
    id      => (others => '0'),
    len     => (others => '-'),
    lock    => (others => '-'),
    prot    => (others => '-'),
    qos     => (others => '-'),
    region  => (others => '-'),
    size    => (others => '-'),
    valid   => '0'
  );
  
  type axi4_aw_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4_aw_s2m_default : axi4_aw_s2m_t := (
    ready   => '0'
  );
  
  type axi4_w8_m2s_t is record
    data    : axi4_data8_t;
    last    : std_logic;
    strb    : axi4_strb8_t;
    valid   : std_logic;
  end record;
  constant axi4_w8_m2s_default : axi4_w8_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w16_m2s_t is record
    data    : axi4_data16_t;
    last    : std_logic;
    strb    : axi4_strb16_t;
    valid   : std_logic;
  end record;
  constant axi4_w16_m2s_default : axi4_w16_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w32_m2s_t is record
    data    : axi4_data32_t;
    last    : std_logic;
    strb    : axi4_strb32_t;
    valid   : std_logic;
  end record;
  constant axi4_w32_m2s_default : axi4_w32_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w64_m2s_t is record
    data    : axi4_data64_t;
    last    : std_logic;
    strb    : axi4_strb64_t;
    valid   : std_logic;
  end record;
  constant axi4_w64_m2s_default : axi4_w64_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w128_m2s_t is record
    data    : axi4_data128_t;
    last    : std_logic;
    strb    : axi4_strb128_t;
    valid   : std_logic;
  end record;
  constant axi4_w128_m2s_default : axi4_w128_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w256_m2s_t is record
    data    : axi4_data256_t;
    last    : std_logic;
    strb    : axi4_strb256_t;
    valid   : std_logic;
  end record;
  constant axi4_w256_m2s_default : axi4_w256_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w512_m2s_t is record
    data    : axi4_data512_t;
    last    : std_logic;
    strb    : axi4_strb512_t;
    valid   : std_logic;
  end record;
  constant axi4_w512_m2s_default : axi4_w512_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w1024_m2s_t is record
    data    : axi4_data1024_t;
    last    : std_logic;
    strb    : axi4_strb1024_t;
    valid   : std_logic;
  end record;
  constant axi4_w1024_m2s_default : axi4_w1024_m2s_t := (
    data    => (others => '-'),
    last    => '-',
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4_w_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4_w_s2m_default : axi4_w_s2m_t := (
    ready   => '0'
  );

  type axi4_r_m2s_t is record
    ready   : std_logic;
  end record;
  constant axi4_r_m2s_default : axi4_r_m2s_t := (
    ready   => '0'
  );

  type axi4_r8_s2m_t is record
    data    : axi4_data8_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r8_s2m_default : axi4_r8_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r16_s2m_t is record
    data    : axi4_data16_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r16_s2m_default : axi4_r16_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r32_s2m_t is record
    data    : axi4_data32_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r32_s2m_default : axi4_r32_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r64_s2m_t is record
    data    : axi4_data64_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r64_s2m_default : axi4_r64_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r128_s2m_t is record
    data    : axi4_data128_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r128_s2m_default : axi4_r128_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r256_s2m_t is record
    data    : axi4_data256_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r256_s2m_default : axi4_r256_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r512_s2m_t is record
    data    : axi4_data512_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r512_s2m_default : axi4_r512_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_r1024_s2m_t is record
    data    : axi4_data1024_t;
    id      : axi4_id8_t;
    last    : std_logic;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_r1024_s2m_default : axi4_r1024_s2m_t := (
    data    => (others => '-'),
    id      => (others => '-'),
    last    => '-',
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4_b_m2s_t is record
    ready   : std_logic;
  end record;
  constant axi4_b_m2s_default : axi4_b_m2s_t := (
    ready   => '0'
  );

  type axi4_b_s2m_t is record
    id      : axi4_id8_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4_b_s2m_default : axi4_b_s2m_t := (
    id      => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

        
  --
  -- CHANNELS
  --
  
  type axi4_8_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w8_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_8_m2s_default : axi4_8_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w8_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_8_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r8_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_8_s2m_default : axi4_8_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r8_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_16_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w16_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_16_m2s_default : axi4_16_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w16_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_16_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r16_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_16_s2m_default : axi4_16_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r16_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_32_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w32_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_32_m2s_default : axi4_32_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w32_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_32_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r32_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_32_s2m_default : axi4_32_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r32_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_64_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w64_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_64_m2s_default : axi4_64_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w64_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_64_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r64_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_64_s2m_default : axi4_64_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r64_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_128_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w128_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_128_m2s_default : axi4_128_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w128_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_128_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r128_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_128_s2m_default : axi4_128_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r128_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_256_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w256_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_256_m2s_default : axi4_256_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w256_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_256_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r256_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_256_s2m_default : axi4_256_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r256_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_512_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w512_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_512_m2s_default : axi4_512_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w512_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_512_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r512_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_512_s2m_default : axi4_512_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r512_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );
  
  type axi4_1024_m2s_t is record
    ar : axi4_ar_m2s_t;
    aw : axi4_aw_m2s_t;
    r  : axi4_r_m2s_t;
    w  : axi4_w1024_m2s_t;
    b  : axi4_b_m2s_t;
  end record;
  constant axi4_1024_m2s_default : axi4_1024_m2s_t := (
    ar => axi4_ar_m2s_default,
    aw => axi4_aw_m2s_default,
    r => axi4_r_m2s_default,
    w => axi4_w1024_m2s_default,
    b => axi4_b_m2s_default
  );
  
  type axi4_1024_s2m_t is record
    ar : axi4_ar_s2m_t;
    aw : axi4_aw_s2m_t;
    r  : axi4_r1024_s2m_t;
    w  : axi4_w_s2m_t;
    b  : axi4_b_s2m_t;
  end record;
  constant axi4_1024_s2m_default : axi4_1024_s2m_t := (
    ar => axi4_ar_s2m_default,
    aw => axi4_aw_s2m_default,
    r => axi4_r1024_s2m_default,
    w => axi4_w_s2m_default,
    b => axi4_b_s2m_default
  );

  type axi4_8_m2s_array_t is array (natural range <>) of axi4_8_m2s_t;
  type axi4_8_s2m_array_t is array (natural range <>) of axi4_8_s2m_t;
  type axi4_16_m2s_array_t is array (natural range <>) of axi4_16_m2s_t;
  type axi4_16_s2m_array_t is array (natural range <>) of axi4_16_s2m_t;
  type axi4_32_m2s_array_t is array (natural range <>) of axi4_32_m2s_t;
  type axi4_32_s2m_array_t is array (natural range <>) of axi4_32_s2m_t;
  type axi4_64_m2s_array_t is array (natural range <>) of axi4_64_m2s_t;
  type axi4_64_s2m_array_t is array (natural range <>) of axi4_64_s2m_t;
  type axi4_128_m2s_array_t is array (natural range <>) of axi4_128_m2s_t;
  type axi4_128_s2m_array_t is array (natural range <>) of axi4_128_s2m_t;
  type axi4_256_m2s_array_t is array (natural range <>) of axi4_256_m2s_t;
  type axi4_256_s2m_array_t is array (natural range <>) of axi4_256_s2m_t;
  type axi4_512_m2s_array_t is array (natural range <>) of axi4_512_m2s_t;
  type axi4_512_s2m_array_t is array (natural range <>) of axi4_512_s2m_t;
  type axi4_1024_m2s_array_t is array (natural range <>) of axi4_1024_m2s_t;
  type axi4_1024_s2m_array_t is array (natural range <>) of axi4_1024_s2m_t;
  
end package;


package body axi4_profile is


end package body;
