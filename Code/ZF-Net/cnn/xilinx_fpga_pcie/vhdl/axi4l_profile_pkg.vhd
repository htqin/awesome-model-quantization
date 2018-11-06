--
-- AXI4-Lite Profile Definitions
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.axi4_field.all;

package axi4l_profile is

  --
  -- SUBCHANNELS
  --
  
  type axi4l_ar_m2s_t is record
    addr    : axi4_addr64_t;
    valid   : std_logic;
  end record;
  constant axi4l_ar_m2s_default : axi4l_ar_m2s_t := (
    addr    => (others => '-'),
    valid   => '0'
  );
  
  type axi4l_ar_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4l_ar_s2m_default : axi4l_ar_s2m_t := (
    ready   => '0'
  );
  
  type axi4l_aw_m2s_t is record
    addr    : axi4_addr64_t;
    valid   : std_logic;
  end record;
  constant axi4l_aw_m2s_default : axi4l_aw_m2s_t := (
    addr    => (others => '-'),
    valid   => '0'
  );
  
  type axi4l_aw_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4l_aw_s2m_default : axi4l_aw_s2m_t := (
    ready   => '0'
  );
  
  type axi4l_w8_m2s_t is record
    data    : axi4_data8_t;
    strb    : axi4_strb8_t;
    valid   : std_logic;
  end record;
  constant axi4l_w8_m2s_default : axi4l_w8_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w16_m2s_t is record
    data    : axi4_data16_t;
    strb    : axi4_strb16_t;
    valid   : std_logic;
  end record;
  constant axi4l_w16_m2s_default : axi4l_w16_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w32_m2s_t is record
    data    : axi4_data32_t;
    strb    : axi4_strb32_t;
    valid   : std_logic;
  end record;
  constant axi4l_w32_m2s_default : axi4l_w32_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w64_m2s_t is record
    data    : axi4_data64_t;
    strb    : axi4_strb64_t;
    valid   : std_logic;
  end record;
  constant axi4l_w64_m2s_default : axi4l_w64_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w128_m2s_t is record
    data    : axi4_data128_t;
    strb    : axi4_strb128_t;
    valid   : std_logic;
  end record;
  constant axi4l_w128_m2s_default : axi4l_w128_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w256_m2s_t is record
    data    : axi4_data256_t;
    strb    : axi4_strb256_t;
    valid   : std_logic;
  end record;
  constant axi4l_w256_m2s_default : axi4l_w256_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w512_m2s_t is record
    data    : axi4_data512_t;
    strb    : axi4_strb512_t;
    valid   : std_logic;
  end record;
  constant axi4l_w512_m2s_default : axi4l_w512_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w1024_m2s_t is record
    data    : axi4_data1024_t;
    strb    : axi4_strb1024_t;
    valid   : std_logic;
  end record;
  constant axi4l_w1024_m2s_default : axi4l_w1024_m2s_t := (
    data    => (others => '-'),
    strb    => (others => '-'),
    valid   => '0'
  );

  type axi4l_w_s2m_t is record
    ready   : std_logic;
  end record;
  constant axi4l_w_s2m_default : axi4l_w_s2m_t := (
    ready   => '0'
  );

  type axi4l_r_m2s_t is record
    ready   : std_logic;
  end record;
  constant axi4l_r_m2s_default : axi4l_r_m2s_t := (
    ready   => '0'
  );

  type axi4l_r8_s2m_t is record
    data    : axi4_data8_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r8_s2m_default : axi4l_r8_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r16_s2m_t is record
    data    : axi4_data16_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r16_s2m_default : axi4l_r16_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r32_s2m_t is record
    data    : axi4_data32_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r32_s2m_default : axi4l_r32_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r64_s2m_t is record
    data    : axi4_data64_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r64_s2m_default : axi4l_r64_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r128_s2m_t is record
    data    : axi4_data128_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r128_s2m_default : axi4l_r128_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r256_s2m_t is record
    data    : axi4_data256_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r256_s2m_default : axi4l_r256_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r512_s2m_t is record
    data    : axi4_data512_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r512_s2m_default : axi4l_r512_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_r1024_s2m_t is record
    data    : axi4_data1024_t;
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_r1024_s2m_default : axi4l_r1024_s2m_t := (
    data    => (others => '-'),
    resp    => (others => '-'),
    valid   => '0'
  );

  type axi4l_b_m2s_t is record
    ready   : std_logic;
  end record;
  constant axi4l_b_m2s_default : axi4l_b_m2s_t := (
    ready   => '0'
  );

  type axi4l_b_s2m_t is record
    resp    : axi4_resp_t;
    valid   : std_logic;
  end record;
  constant axi4l_b_s2m_default : axi4l_b_s2m_t := (
    resp    => (others => '-'),
    valid   => '0'
  );

        
  --
  -- CHANNELS
  --
  
  type axi4l_8_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w8_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_8_m2s_default : axi4l_8_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w8_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_8_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r8_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_8_s2m_default : axi4l_8_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r8_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_16_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w16_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_16_m2s_default : axi4l_16_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w16_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_16_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r16_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_16_s2m_default : axi4l_16_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r16_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_32_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w32_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_32_m2s_default : axi4l_32_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w32_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_32_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r32_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_32_s2m_default : axi4l_32_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r32_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_64_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w64_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_64_m2s_default : axi4l_64_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w64_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_64_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r64_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_64_s2m_default : axi4l_64_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r64_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_128_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w128_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_128_m2s_default : axi4l_128_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w128_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_128_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r128_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_128_s2m_default : axi4l_128_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r128_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_256_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w256_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_256_m2s_default : axi4l_256_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w256_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_256_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r256_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_256_s2m_default : axi4l_256_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r256_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_512_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w512_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_512_m2s_default : axi4l_512_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w512_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_512_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r512_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_512_s2m_default : axi4l_512_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r512_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );
  
  type axi4l_1024_m2s_t is record
    ar : axi4l_ar_m2s_t;
    aw : axi4l_aw_m2s_t;
    r  : axi4l_r_m2s_t;
    w  : axi4l_w1024_m2s_t;
    b  : axi4l_b_m2s_t;
  end record;
  constant axi4l_1024_m2s_default : axi4l_1024_m2s_t := (
    ar => axi4l_ar_m2s_default,
    aw => axi4l_aw_m2s_default,
    r => axi4l_r_m2s_default,
    w => axi4l_w1024_m2s_default,
    b => axi4l_b_m2s_default
  );
  
  type axi4l_1024_s2m_t is record
    ar : axi4l_ar_s2m_t;
    aw : axi4l_aw_s2m_t;
    r  : axi4l_r1024_s2m_t;
    w  : axi4l_w_s2m_t;
    b  : axi4l_b_s2m_t;
  end record;
  constant axi4l_1024_s2m_default : axi4l_1024_s2m_t := (
    ar => axi4l_ar_s2m_default,
    aw => axi4l_aw_s2m_default,
    r => axi4l_r1024_s2m_default,
    w => axi4l_w_s2m_default,
    b => axi4l_b_s2m_default
  );


  type axi4l_32_m2s_array_t is array (natural range <>) of axi4l_32_m2s_t;
  type axi4l_32_s2m_array_t is array (natural range <>) of axi4l_32_s2m_t;
  type axi4l_64_m2s_array_t is array (natural range <>) of axi4l_64_m2s_t;
  type axi4l_64_s2m_array_t is array (natural range <>) of axi4l_64_s2m_t;
  
  
end package;


package body axi4l_profile is


end package body;
