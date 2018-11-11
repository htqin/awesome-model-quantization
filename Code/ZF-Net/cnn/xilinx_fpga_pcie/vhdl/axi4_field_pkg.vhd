--
-- AXI4 Field Definitions
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

package axi4_field is

  --
  -- FIELDS
  --
  
  subtype axi4_addr32_t is std_logic_vector(31 downto 0);
  subtype axi4_addr64_t is std_logic_vector(63 downto 0);
  
  function axi4_addr_valid(
    addr : in    std_logic_vector)
  return boolean;
  
  
  subtype axi4_burst_t is std_logic_vector(1 downto 0);
  constant axi4_burst_fixed : axi4_burst_t := "00";
  constant axi4_burst_incr  : axi4_burst_t := "01";
  constant axi4_burst_wrap  : axi4_burst_t := "10";
  constant axi4_burst_resvd : axi4_burst_t := "11";
  
  function axi4_burst_to_string(
    constant burst : in    axi4_burst_t)
  return string;
  
  function axi4_burst_valid(
    burst : in    axi4_burst_t)
  return boolean;
  
  
  subtype axi4_cache_t is std_logic_vector(3 downto 0);
  constant axi4_cache_normal : axi4_cache_t := "0011";
  constant axi4_cache_default : axi4_cache_t := axi4_cache_normal;
  
  
  subtype axi4_id8_t is std_logic_vector(7 downto 0);
  
  function axi4_id_valid(
    id : in    axi4_id8_t)
  return boolean;
  
  
  subtype axi4_len8_t is std_logic_vector(7 downto 0);
  
  function axi4_len_valid(
    len : in    axi4_len8_t)
  return boolean;
  
  function axi4_burst_len_valid(
    burst : in    axi4_burst_t;
    len   : in    axi4_len8_t)
  return boolean;
  
  
  subtype axi4_lock_t is std_logic_vector(0 downto 0);
  
  
  subtype axi4_prot_t is std_logic_vector(2 downto 0);
  
  
  subtype axi4_qos_t is std_logic_vector(3 downto 0);
  
  
  subtype axi4_region_t is std_logic_vector(3 downto 0);
  
  
  subtype axi4_size_t is std_logic_vector(2 downto 0);
  
  function axi4_size_valid(
    size : in    axi4_size_t)
  return boolean;
  
  
  subtype axi4_data8_t is std_logic_vector(7 downto 0);
  subtype axi4_data16_t is std_logic_vector(15 downto 0);
  subtype axi4_data32_t is std_logic_vector(31 downto 0);
  subtype axi4_data64_t is std_logic_vector(63 downto 0);
  subtype axi4_data128_t is std_logic_vector(127 downto 0);
  subtype axi4_data256_t is std_logic_vector(255 downto 0);
  subtype axi4_data512_t is std_logic_vector(511 downto 0);
  subtype axi4_data1024_t is std_logic_vector(1023 downto 0);
  
  
  subtype axi4_strb8_t is std_logic_vector(0 downto 0);
  subtype axi4_strb16_t is std_logic_vector(1 downto 0);
  subtype axi4_strb32_t is std_logic_vector(3 downto 0);
  subtype axi4_strb64_t is std_logic_vector(7 downto 0);
  subtype axi4_strb128_t is std_logic_vector(15 downto 0);
  subtype axi4_strb256_t is std_logic_vector(31 downto 0);
  subtype axi4_strb512_t is std_logic_vector(63 downto 0);
  subtype axi4_strb1024_t is std_logic_vector(127 downto 0);
  
  
  subtype axi4_last_t is std_logic;
  
  
  subtype axi4_resp_t is std_logic_vector(1 downto 0);
  constant axi4_resp_okay   : axi4_resp_t := "00";
  constant axi4_resp_exokay : axi4_resp_t := "01";
  constant axi4_resp_slverr : axi4_resp_t := "10";
  constant axi4_resp_decerr : axi4_resp_t := "11";
  
  function axi4_resp_to_string(
    constant resp : in    axi4_resp_t)
  return string;

  function axi4_resp_is_ok(
    constant resp : in    axi4_resp_t)
  return boolean;

  function axi4_resp_valid(
    constant resp : in    axi4_resp_t)
  return boolean;

  
end package;


package body axi4_field is

  --
  -- PRIVATE
  --
    
  function slv_valid(
    constant slv : in    std_logic_vector)
  return boolean is
  begin
    return to_X01(or_reduce(slv)) /= 'X' and to_X01(and_reduce(slv)) /= 'X';
  end;
  
  
  --
  -- PUBLIC
  --
  
  function axi4_addr_valid(
    addr : in    std_logic_vector)
  return boolean is
  begin
    return slv_valid(addr);
  end;
  
  function axi4_burst_to_string(
    constant burst : in    axi4_burst_t)
  return string is
  begin
    case burst is
      when axi4_burst_fixed =>
        return "FIXED";
        
      when axi4_burst_incr =>
        return "INCR";
        
      when axi4_burst_wrap =>
        return "WRAP";
        
      when axi4_burst_resvd =>
        return "RESERVED";
        
      when others =>
        return "INVALID:" & std_logic'image(burst(1)) & std_logic'image(burst(0));
    end case;
  end;
    
  function axi4_burst_valid(
    burst : in    axi4_burst_t)
  return boolean is
  begin
    case burst is
      when axi4_burst_fixed | axi4_burst_incr | axi4_burst_wrap =>
        return true;
        
      when others =>
        return false;
    end case;
  end;
  
  function axi4_id_valid(
    id : in    axi4_id8_t)
  return boolean is
  begin
    return slv_valid(id);
  end;
  
  function axi4_len_valid(
    len : in    axi4_len8_t)
  return boolean is
  begin
    return slv_valid(len);
  end;
  
  function axi4_burst_len_valid(
    burst : in    axi4_burst_t;
    len   : in    axi4_len8_t)
  return boolean is
  begin
    if not axi4_burst_valid(burst) then
      return false;
    end if;
    if not axi4_len_valid(len) then
      return false;
    end if;
    if burst = axi4_burst_wrap then
      -- LEN must represent a number of beats that is a power of 2, in order to be valid.
      case len is
        when X"00" | X"01" | X"03" | X"07" | X"0F" | X"1F" | X"3F" | X"7F" | X"FF" =>
          return true;
          
        when others =>
          return false;
      end case;
    end if;
  end;
    
  function axi4_size_valid(
    size : in    axi4_size_t)
  return boolean is
  begin
    return slv_valid(size);
  end;
  
  function axi4_resp_to_string(
    constant resp : in    axi4_resp_t)
  return string is
  begin
    case resp is
      when axi4_resp_okay =>
        return "OKAY";
        
      when axi4_resp_exokay =>
        return "EXOKAY";
        
      when axi4_resp_slverr =>
        return "SLVERR";
        
      when axi4_resp_decerr =>
        return "DECERR";
        
      when others =>
        return "INVALID:" & std_logic'image(resp(1)) & std_logic'image(resp(0));
    end case;
  end;
  
  function axi4_resp_is_ok(
    constant resp : in    axi4_resp_t)
  return boolean is
  begin
    return resp = axi4_resp_okay or resp = axi4_resp_exokay;
  end;

  function axi4_resp_valid(
    constant resp : in    axi4_resp_t)
  return boolean is
  begin
    return slv_valid(resp);
  end;


end package body;
