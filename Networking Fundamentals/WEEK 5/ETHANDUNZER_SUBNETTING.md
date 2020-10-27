## SUBNETTING

Convert the following IPv4 addresses into binary.  Include all leading zeros.

192.168.208.63
  - 11000000.10101000.11010000.00111111

10.15.223.44
  - 00001010.00001111.11011111.00101100

172.16.225.20
  - 10101100.00010000.11100001.00010100

187.32.250.112
  - 10111011.00100000.11111010.01110000

172.30.119.99
  - 10101100.00011110.01110111.01100011



Conver the following IPv4 addresses from binary to decimal.
10101100.10010010.00010111.11011011
  - 172.146.23.219

11100110.00010101.00110110.00100100
  - 230.21.54.36

00000011.11111100.11000101.01010101
  - 3.252.197.85

00001010.00001010.11001001.11111111
  - 10.10.201.255



Classless Inter-Domain Routing (CIDR) Subnetting
Instructions:  Using CIDR subnetting, create an IP address scheme using the following scenario.  You will need to create a subnet for each department.  Your subnet must be large enough to include all department users into one subnet.  Hint: you'll need to reference the subnet mask chart, shown in the lecture slides, to determine the proper subnet.

Department	# of Hosts
Sales	4084
Marketing	518
Finance	243
Logistics	112
Administration	67
IT Department	25
Router-to-Router A	2
Router-to-Router B	2
Router-to-Router C	2
Your beginning network ID is: 172.18.0.0/16

For each subnet, you will need to show:

Subnet 1
  Department name
    - Sales
  Network ID
    - 172.18.0.0/20
  Host IP Range
    - 172.18.0.0 - 172.18.15.254
  Broadcast IP
    - 172.18.15.254

Subnet 2
  Department name
    - Marketing
  Network ID
    - 172.18.16.0/22
  Host IP Range
    - 172.18.16.1 - 172.18.19.254
  Broadcast IP
    - 172.18.19.255

Subnet 3
  Department name
    - Finance
  Network ID
    - 172.18.20.0/24
  Host Ip Range
    - 172.18.20.1 - 172.18.20.254
  Broadcast IP
    - 172.18.20.255

Subnet 4
  Department name
    - Logistics
  Network ID
    - 172.18.21.0/25
  Host IP Range
    - 172.18.21.1 - 172.18.21.126
  Broadcast IP
    - 172.18.21.127

Subnet 5
  Department name
    - Administration
  Network ID
    - 172.18.21.128/25
  Host IP Range
    - 172.18.21.129 - 172.18.21.254
  Broadcast IP
    - 172.18.21.255

Subnet 6
  Department name
    - IT Department
  Network ID
    - 172.18.22.0/27
  Host IP Range
    - 172.18.22.1 - 172.18.22.30
  Broadcast IP
    - 172.18.22.31


Variable-Length Subnet Masking (VLSM)
Instructions:  Like the last scenario, you will create a subnet for each department.  This time, you are going to use VLSM to find the right-sized subnet for each department.  When creating your network ID, make sure you include CIDR notation.  Hint: you will need to utilize the subnet mask table from the lecture slides to find the correct sized subnet.

Department	# of Hosts
Sales	4095
Marketing	509
Finance	220
Logistics	99
Administration	95
IT Department	24
Printers	10
Router-to-Router A	2
Router-to-Router B	2
Your beginning network ID is: 172.27.0.0/16

For each subnet, you will need to show:

Subnet 1
  Department name
    - Sales
  Network ID
    - 172.27.0.0/20
  Host IP Range
    - 172.27.0.1 - 172.27.15.254
  Broadcast IP
    - 172.27.15.255

Subnet 2
  Department name
    - Marketing
  Network ID
    - 172.27.16.0/23
  Host IP Range
    - 172.27.16.1 - 172.27.17.254
  Broadcast IP
    - 172.27.17.255

Subnet 3
  Department name
    - Finance
  Network ID
    - 172.27.18.0/24
  Host Ip Range
    - 172.27.18.1 - 172.27.18.254
  Broadcast IP
    - 172.27.18.255

Subnet 4
  Department name
    - Logistics
  Network ID
    - 172.27.19.0/25
  Host IP Range
    -	172.27.19.1 - 172.27.19.126
  Broadcast IP
    - 172.27.19.127

Subnet 5
  Department name
    - Administration
  Network ID
    - 172.27.19.128/25
  Host IP Range
    - 172.27.19.129 - 172.27.19.254
  Broadcast IP
    - 172.27.19.255

Subnet 6
  Department name
    - IT Department
  Network ID
    - 172.27.20.0/27
  Host IP Range
    - 172.27.20.1 - 172.27.20.30
  Broadcast IP
    - 172.27.20.31

Subnet 7
  Department name
    - Printers
  Network ID
    - 172.27.20.32/28
  Host IP Range
    - 172.27.20.33 - 172.27.20.46
  Broadcast IP
    - 172.27.20.47
