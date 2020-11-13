## LAB 05

NETWORK LAYOUT

DEVICES:

  ROUTER0
    - g0/0 ip = 172.18.0.1
    - g0/1 ip = 10.10.30.1
    - given password cisco123

  SWITCH0 (connected to switch via g0/0)
    - g0/1 set to trunk mode
    - f0/1-23 set to access mode
    - f0/24 set to trunk mode
    - given password cisco123

  SWITCH1 (connected to switch via g0/1)
    - g0/1 set to trunk mode
    - f0/1-24 set to access mode
    - given password cisco123

  SERVER0 (connected to SWITCH0)
    - static ip of 172.18.0.2
    - DHCP Pool A set to 172.18.0.0/24
    - DHCP Pool B set to 10.10.30.0/24
    - DHCP enabled

  PC's LAN_A1-4 (belong to SWITCH0)
    - configured for DHCP addresses 172.18.0.0/1-24

  PC's LAN_B1-4 (belong to SWITCH1)
    - configured for DHCP addresses 10.10.30.0/1-24
