library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.std_logic_arith.all;

entity xc7a35tcpg236pkg_port_wrapper is 
    Port  (
        -- CLK
        W5  : in  std_logic;
        -- SWITCHES [0-15]
        V17 : in  std_logic;
        V16 : in  std_logic;
        W16 : in  std_logic;
        W17 : in  std_logic;
        W15 : in  std_logic;
        V15 : in  std_logic;
        W14 : in  std_logic;
        W13 : in  std_logic;
        V2  : in  std_logic;
        T3  : in  std_logic;
        T2  : in  std_logic;
        R3  : in  std_logic;
        W2  : in  std_logic;
        U1  : in  std_logic;
        T1  : in  std_logic;
        R2  : in  std_logic; 
        -- LEDS [0-15]
        U16 : out std_logic;
        E19 : out std_logic;
        U19 : out std_logic;
        V19 : out std_logic;
        W18 : out std_logic;
        U15 : out std_logic;
        U14 : out std_logic;
        V14 : out std_logic;
        V13 : out std_logic;
        V3  : out std_logic;
        W3  : out std_logic;
        U3  : out std_logic;
        P3  : out std_logic;
        N3  : out std_logic;
        P1  : out std_logic;
        L1  : out std_logic;
        -- 7 SEGMENT DISPLAY ACTIVE SEGMENTS VALUES [0-6]
        W7  : out std_logic;
        W6  : out std_logic;
        U8  : out std_logic;
        V8  : out std_logic;
        U5  : out std_logic;
        V5  : out std_logic;
        U7  : out std_logic;
        -- 7 SEGMENT DISPLAY CURRENT ACTIVE DISPLAY [0-3] (NOTE: only 1 should be active at a time)
        U2  : out std_logic;
        U4  : out std_logic;
        V4  : out std_logic;
        W4  : out std_logic;
        -- DISPLAY ENABLE
        V7  : out std_logic;
        -- BUTTONS [center, up, left, right, down]
        U18 : in std_logic;
        T18 : in std_logic;
        W19 : in std_logic;
        T17 : in std_logic;
        U17 : in std_logic;
        -- VGA [RED0-3, BLUE0-3, GREEN0-3, HSYNC, VSYNC]
        G19 : out std_logic;
        H19 : out std_logic;
        J19 : out std_logic;
        N19 : out std_logic;
        N18 : out std_logic;
        L18 : out std_logic;
        K18 : out std_logic;
        J18 : out std_logic;
        J17 : out std_logic;
        H17 : out std_logic;
        G17 : out std_logic;
        D17 : out std_logic;
        P19 : out std_logic;
        R19 : out std_logic);
        
end xc7a35tcpg236pkg_port_wrapper;

architecture rtl of xc7a35tcpg236pkg_port_wrapper is
    
    component basys3_port_wrapper
    port (    
        clk   : in  std_logic;
        BTNL  : in  std_logic;
        BTNR  : in  std_logic;
        BTNU  : in  std_logic;
        BTND  : in  std_logic;
        BTNC  : in  std_logic;
        --
        SW0   : in  std_logic;
        SW1   : in  std_logic;
        SW2   : in  std_logic;
        SW3   : in  std_logic;
        SW4   : in  std_logic;
        SW5   : in  std_logic;
        SW6   : in  std_logic;
        SW7   : in  std_logic;
        SW8   : in  std_logic;
        SW9   : in  std_logic;
        SW10  : in  std_logic;
        SW11  : in  std_logic;
        SW12  : in  std_logic;
        SW13  : in  std_logic;
        SW14  : in  std_logic;
        SW15  : in  std_logic;
        --
        LD0   : out std_logic;
        LD1   : out std_logic;
        LD2   : out std_logic;
        LD3   : out std_logic;
        LD4   : out std_logic;
        LD5   : out std_logic;
        LD6   : out std_logic;
        LD7   : out std_logic;
        LD8   : out std_logic;
        LD9   : out std_logic;
        LD10  : out std_logic;
        LD11  : out std_logic;
        LD12  : out std_logic;
        LD13  : out std_logic;
        LD14  : out std_logic;
        LD15  : out std_logic;
        --
        AN0   : out std_logic;
        AN1   : out std_logic;
        AN2   : out std_logic;
        AN3   : out std_logic;
        CA    : out std_logic;
        CB    : out std_logic;
        CC    : out std_logic;
        CD    : out std_logic;
        CE    : out std_logic;
        CF    : out std_logic;
        CG    : out std_logic;
        DP    : out std_logic;
        --
        RED0  : out std_logic;
        RED1  : out std_logic;
        RED2  : out std_logic;
        RED3  : out std_logic;
        GRN0  : out std_logic;
        GRN1  : out std_logic;
        GRN2  : out std_logic;
        GRN3  : out std_logic;
        BLU0  : out std_logic;
        BLU1  : out std_logic;
        BLU2  : out std_logic;
        BLU3  : out std_logic;
        HSYNC : out std_logic;
        VSYNC : out std_logic);
    end component;
    
    signal BTNL  : std_logic;
    signal BTNR  : std_logic;
    signal BTNU  : std_logic;
    signal BTND  : std_logic;
    signal BTNC  : std_logic;
    --
    signal SW0   : std_logic;
    signal SW1   : std_logic;
    signal SW2   : std_logic;
    signal SW3   : std_logic;
    signal SW4   : std_logic;
    signal SW5   : std_logic;
    signal SW6   : std_logic;
    signal SW7   : std_logic;
    signal SW8   : std_logic;
    signal SW9   : std_logic;
    signal SW10  : std_logic;
    signal SW11  : std_logic;
    signal SW12  : std_logic;
    signal SW13  : std_logic;
    signal SW14  : std_logic;
    signal SW15  : std_logic;
    --
    signal LD0   : std_logic;
    signal LD1   : std_logic;
    signal LD2   : std_logic;
    signal LD3   : std_logic;
    signal LD4   : std_logic;
    signal LD5   : std_logic;
    signal LD6   : std_logic;
    signal LD7   : std_logic;
    signal LD8   : std_logic;
    signal LD9   : std_logic;
    signal LD10  : std_logic;
    signal LD11  : std_logic;
    signal LD12  : std_logic;
    signal LD13  : std_logic;
    signal LD14  : std_logic;
    signal LD15  : std_logic;
    --
    signal AN0 : std_logic;
    signal AN1 : std_logic;
    signal AN2 : std_logic;
    signal AN3 : std_logic;
    --
    signal CA  : std_logic;
    signal CB  : std_logic;
    signal CC  : std_logic;
    signal CD  : std_logic;
    signal CE  : std_logic;
    signal CF  : std_logic;
    signal CG  : std_logic;
    signal DP  : std_logic;
    --
    signal RED0 : std_logic;
    signal RED1 : std_logic;
    signal RED2 : std_logic;
    signal RED3 : std_logic;
    signal GRN0 : std_logic;
    signal GRN1 : std_logic;
    signal GRN2 : std_logic;
    signal GRN3 : std_logic;
    signal BLU0 : std_logic;
    signal BLU1 : std_logic;
    signal BLU2 : std_logic;
    signal BLU3 : std_logic;
    --
    signal HSYNC : std_logic;
    signal VSYNC : std_logic;
    --
    signal clk   : std_logic;
    
begin
    
    clk <= W5;
    --
    BTNC <= U18;
    BTNU <= T18;
    BTNL <= W19;
    BTNR <= T17;
    BTND <= U17;
    --
    SW0  <= V17;
    SW1  <= V16;
    SW2  <= W16;
    SW3  <= W17;
    SW4  <= W15;
    SW5  <= V15;
    SW6  <= W14;
    SW7  <= W13;
    SW8  <= V2;
    SW9  <= T3;
    SW10 <= T2;
    SW11 <= R3;
    SW12 <= W2;
    SW13 <= U1;
    SW14 <= T1;
    SW15 <= R2;
    --
    U16 <= LD0;
    E19 <= LD1;
    U19 <= LD2;
    V19 <= LD3;
    W18 <= LD4;
    U15 <= LD5;
    U14 <= LD6;
    V14 <= LD7;
    V13 <= LD8;
    V3  <= LD9;
    W3  <= LD10;
    U3  <= LD11;
    P3  <= LD12;
    N3  <= LD13;
    P1  <= LD14;
    L1  <= LD15;
    --
    W7  <= CA;
    W6  <= CB;
    U8  <= CC;
    V8  <= CD;
    U5  <= CE;
    V5  <= CF;
    U7  <= CG;
    V7  <= DP;
    --   
    U2 <= AN0;
    U4 <= AN1;
    V4 <= AN2;
    W4 <= AN3;
    
    G19 <= RED0;
    H19 <= RED1;
    J19 <= RED2;
    N19 <= RED3;
    J17 <= GRN0;
    H17 <= GRN1;
    G17 <= GRN2;
    D17 <= GRN3;
    N18 <= BLU0;
    L18 <= BLU1;
    K18 <= BLU2;
    J18 <= BLU3;
    P19 <= HSYNC;
    R19 <= VSYNC;
    
    
    -- Instance of Basys 3 port wrapper
    -- Each port is assigned to its appropriate pin above so that the assigned signal can match the port name
    u_basys3_port_wrapper : basys3_port_wrapper
    port map (
        clk   => clk,
        BTNL  => BTNL,
        BTNR  => BTNR,
        BTNU  => BTNU,
        BTND  => BTND,
        BTNC  => BTNC,
        SW0   => SW0,
        SW1   => SW1,
        SW2   => SW2,
        SW3   => SW3,
        SW4   => SW4,
        SW5   => SW5,
        SW6   => SW6,
        SW7   => SW7,
        SW8   => SW8,
        SW9   => SW9,
        SW10  => SW10,
        SW11  => SW11,
        SW12  => SW12,
        SW13  => SW13,
        SW14  => SW14,
        SW15  => SW15,
        LD0   => LD0,
        LD1   => LD1,
        LD2   => LD2,
        LD3   => LD3,
        LD4   => LD4,
        LD5   => LD5,
        LD6   => LD6,
        LD7   => LD7,
        LD8   => LD8,
        LD9   => LD9,
        LD10  => LD10,
        LD11  => LD11,
        LD12  => LD12,
        LD13  => LD13,
        LD14  => LD14,
        LD15  => LD15,
        AN0   => AN0,
        AN1   => AN1,
        AN2   => AN2,
        AN3   => AN3,
        CA    => CA,
        CB    => CB,
        CC    => CC,
        CD    => CD,
        CE    => CE,
        CF    => CF,
        CG    => CG,
        DP    => DP,
        RED0  => RED0,
        RED1  => RED1,
        RED2  => RED2,
        RED3  => RED3,
        GRN0  => GRN0,
        GRN1  => GRN1,
        GRN2  => GRN2,
        GRN3  => GRN3,
        BLU0  => BLU0,
        BLU1  => BLU1,
        BLU2  => BLU2,
        BLU3  => BLU3,
        HSYNC => HSYNC,
        VSYNC => VSYNC);
   
end rtl;