library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.std_logic_arith.all;

-- Basys 3 uses xc7a35tcpg236-1 Artix-7 FPGA from Xilinx
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
        -- RS-232 (UART TX and RX pins)
        A18 : out std_logic;
        B18 : in  std_logic;
        -- PMOD JA
        J1 : inout std_logic;
        L2 : inout std_logic;
        J2 : inout std_logic;
        G2 : inout std_logic;
        H1 : inout std_logic;
        K2 : inout std_logic;
        H2 : inout std_logic;
        G3 : inout std_logic;
        -- PMOD JB
        A14 : inout std_logic;
        A16 : inout std_logic;
        B15 : inout std_logic;
        B16 : inout std_logic;
        A15 : inout std_logic;
        A17 : inout std_logic;
        C15 : inout std_logic;
        C16 : inout std_logic;
        -- PMOD JC
        K17 : inout std_logic;
        M18 : inout std_logic;
        N17 : inout std_logic;
        P18 : inout std_logic;
        L17 : inout std_logic;
        M19 : inout std_logic;
        P17 : inout std_logic;
        R18 : inout std_logic;
        -- PMOD XADC
        J3 : inout std_logic;
        L3 : inout std_logic;
        M2 : inout std_logic;
        N2 : inout std_logic;
        K3 : inout std_logic;
        M3 : inout std_logic;
        M1 : inout std_logic;
        N1 : inout std_logic;        
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
        
begin
    
    basys3_port_wrapper : entity work.basys3_port_wrapper
    port map (
        clk   => W5,
        BTNL  => W19,
        BTNR  => T17,
        BTNU  => T18,
        BTND  => U17,
        BTNC  => U18,
        --        
        SW0   => V17,
        SW1   => V16,
        SW2   => W16,
        SW3   => W17,
        SW4   => W15,
        SW5   => V15,
        SW6   => W14,
        SW7   => W13,
        SW8   => V2,
        SW9   => T3,
        SW10  => T2,
        SW11  => R3,
        SW12  => W2,
        SW13  => U1,
        SW14  => T1,
        SW15  => R2,
        -- LEDs    
        LD0   => U16,
        LD1   => E19,
        LD2   => U19,
        LD3   => V19,
        LD4   => W18,
        LD5   => U15,
        LD6   => U14,
        LD7   => V14,
        LD8   => V13,
        LD9   => V3,
        LD10  => W3,
        LD11  => U3,
        LD12  => P3,
        LD13  => N3,
        LD14  => P1,
        LD15  => L1,
        -- 7-Segment Display
        AN0   => U2,
        AN1   => U4,
        AN2   => V4,
        AN3   => W4,    
        CA    => W7,
        CB    => W6,
        CC    => U8,
        CD    => V8,
        CE    => U5,
        CF    => V5,
        CG    => U7,
        DP    => V7,    
        -- UART
        RXD   => B18,
        TXD   => A18,
        -- PMOD JA           
        JA1   => J1,
        JA2   => L2,
        JA3   => J2,
        JA4   => G2,
        JA7   => H1,
        JA8   => K2,
        JA9   => H2,
        JA10  => G3,
        -- PMOD JB
        JB1   => A14,
        JB2   => A16,
        JB3   => B15,
        JB4   => B16,
        JB7   => A15,
        JB8   => A17,
        JB9   => C15, 
        JB10  => C16,          
        --        
        JC1   => K17,
        JC2   => M18,
        JC3   => N17,
        JC4   => P18,
        JC7   => L17,
        JC8   => M19,
        JC9   => P17,        
        JC10  => R18,   
        --             
        JXADC1   => J3,
        JXADC2   => L3,
        JXADC3   => M2,
        JXADC4   => N2,
        JXADC7   => K3,
        JXADC8   => M3,
        JXADC9   => M1,        
        JXADC10  => N1,       
        --
        RED0  => G19,
        RED1  => H19,
        RED2  => J19,
        RED3  => N19,
        GRN0  => J17,
        GRN1  => H17,
        GRN2  => G17,
        GRN3  => D17,
        BLU0  => N18,
        BLU1  => L18,
        BLU2  => J18,
        BLU3  => J18,
        HSYNC => P19,
        VSYNC => R19);
   
end rtl;