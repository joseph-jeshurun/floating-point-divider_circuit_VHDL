library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Final is
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           y : in  STD_LOGIC_VECTOR (7 downto 0);
           z : out  STD_LOGIC_VECTOR (7 downto 0));
end Final;

architecture Behavioral of Final is

signal x_mantissa : STD_LOGIC_VECTOR (3 downto 0);
signal x_exponent : STD_LOGIC_VECTOR (2 downto 0);
signal x_sign : STD_LOGIC;
signal y_mantissa : STD_LOGIC_VECTOR (3 downto 0);
signal y_exponent : STD_LOGIC_VECTOR (2 downto 0);
signal y_sign : STD_LOGIC;
signal z_mantissa : STD_LOGIC_VECTOR (3 downto 0);
signal z_exponent : STD_LOGIC_VECTOR (2 downto 0);
signal z_sign : STD_LOGIC;
signal a : STD_LOGIC_VECTOR (6 downto 0);
signal temp_1 : STD_LOGIC_VECTOR (5 downto 0);
signal temp_2 : STD_LOGIC_VECTOR (5 downto 0);
signal temp_3 : STD_LOGIC_VECTOR (3 downto 0);

begin 
process(x,y)
variable x_mantissa : STD_LOGIC_VECTOR (3 downto 0);
variable x_exponent : STD_LOGIC_VECTOR (2 downto 0);
variable x_sign : STD_LOGIC;
variable y_mantissa : STD_LOGIC_VECTOR (3 downto 0);
variable y_exponent : STD_LOGIC_VECTOR (2 downto 0);
variable y_sign : STD_LOGIC;
variable z_mantissa : STD_LOGIC_VECTOR (3 downto 0);
variable z_exponent : STD_LOGIC_VECTOR (2 downto 0);
variable z_sign : STD_LOGIC;
variable a : STD_LOGIC_VECTOR (6 downto 0);
variable temp_1 : STD_LOGIC_VECTOR (5 downto 0);
variable temp_2 : STD_LOGIC_VECTOR (5 downto 0);
variable temp_3 : STD_LOGIC_VECTOR (3 downto 0);

begin
x_mantissa := x(3 downto 0);
x_exponent := x(6 downto 4);
x_sign := x(7);
y_mantissa := y(3 downto 0);
y_exponent := y(6 downto 4);
y_sign := y(7);
z_sign := x_sign xor y_sign;

if (y_exponent="111") then 
 z_exponent := "000";
 z_mantissa := (others=>'0');
elsif (y_exponent=0 or x_exponent=7) then 
 z_exponent := "111";
 z_mantissa := (others=>'0');
else
 temp_3 := ('0' & x_exponent) - ('0' & y_exponent) + 3;
 temp_1 := "01" & x_mantissa; 
digit_loop: for i in 6 downto 0 loop
 temp_2 := temp_1 - ("01" & y_mantissa);
 if ( temp_2(5)='0' ) then 
    a(i):='1';
    temp_1 := temp_2;
 else
    a(i):='0';
end if;
temp_1 := temp_1(4 downto 0) & '0'; 
end loop digit_loop;

a := a + 1;
if (a(6)='1') then
 z_mantissa := a(5 downto 2);
else
 z_mantissa := a(4 downto 1);
 temp_3 := temp_3 - 1;
end if;

if (temp_3(3)='1') then
 if (temp_3(2)='1') then
    z_exponent := "000";
    z_mantissa := (others=>'0');
 else 
    z_exponent := "111";
    z_mantissa := (others=>'0');
 end if;
else
  z_exponent := temp_3(2 downto 0);
end if;
end if;
z(3 downto 0) <= z_mantissa;
z(6 downto 4) <= z_exponent;
z(7) <= z_sign;
end process;
end Behavioral;