# gedit lab2.tcl - to open the file in gedit

'''
2. Implement simple ESS and with transmitting nodes
in wire-less LAN by simulation and determine the performance with respect to transmission of packets.
'''
# ESS (Extended Service Set) is a set of connected BSSs (Basic Service Sets) and integrated into an infrastructure network.
# BSS (Basic Service Set) is a set of all stations that can communicate with each other.

set ns [new Simulator]                # Create a new Simulator object and assign it to the variable 'ns'
set tf [open lab2.tr w]               # Open a file named 'lab2.tr' in write mode and assign the file handle to the variable 'tf'
$ns trace-all $tf                     # Enable tracing of all events in the simulator and redirect the output to the file 'lab2.tr'
set topo [new Topography]             # Create a new Topography object and assign it to the variable 'topo'
$topo load_flatgrid 1000 1000         # Load a flat grid topology with dimensions 1000x1000 into the 'topo' object
set nf [open lab2.nam w]               # Open a file named 'lab2.nam' in write mode and assign the file handle to the variable 'nf'
$ns namtrace-all-wireless $nf 1000 1000  # Enable wireless tracing for all nodes in the simulator and redirect the output to the file 'lab2.nam'

$ns node-config -adhocRouting DSDV \  # Configure the nodes in the simulator with the following parameters:
    -llType LL \                      #   - Link layer type: LL (Link Layer)
    -macType Mac/802_11 \             #   - MAC layer type: Mac/802_11 (802.11 Wireless MAC)
    -ifqType Queue/DropTail \          #   - Interface queue type: Queue/DropTail (DropTail Queue)
    -ifqLen 50 \                      #   - Interface queue length: 50
    -phyType Phy/WirelessPhy \         #   - Physical layer type: Phy/WirelessPhy (Wireless Physical Layer)
    -channelType Channel/WirelessChannel \  #   - Channel type: Channel/WirelessChannel (Wireless Channel)
    -propType Propagation/TwoRayGround \     #   - Propagation type: Propagation/TwoRayGround (Two-Ray Ground Propagation)
    -antType Antenna/OmniAntenna \     #   - Antenna type: Antenna/OmniAntenna (Omni-directional Antenna)
    -topoInstance $topo \             #   - Topology instance: 'topo' object created earlier
    -agentTrace ON \                  #   - Enable agent tracing
    -routerTrace ON                   #   - Enable router tracing

create-god 3                          # Create a God object with 3 nodes. God is a helper object that keeps track of the state of the network and provides a way to query the state of the network.
set n0 [$ns node]                     # Create a new node and assign it to the variable 'n0'
set n1 [$ns node]                     # Create a new node and assign it to the variable 'n1'
set n2 [$ns node]                     # Create a new node and assign it to the variable 'n2'
$n0 label "tcp0"                      # Set the label of node 'n0' to "tcp0"
$n1 label "sink1/tcp1"                # Set the label of node 'n1' to "sink1/tcp1"
$n2 label "sink2"                     # Set the label of node 'n2' to "sink2"
$n0 set X_ 50                         # Set the X coordinate of node 'n0' to 50
$n0 set Y_ 50                         # Set the Y coordinate of node 'n0' to 50
$n0 set Z_ 0                          # Set the Z coordinate of node 'n0' to 0
$n1 set X_ 100                        # Set the X coordinate of node 'n1' to 100
$n1 set Y_ 100                        # Set the Y coordinate of node 'n1' to 100
$n1 set Z_ 0                          # Set the Z coordinate of node 'n1' to 0
$n2 set X_ 600                        # Set the X coordinate of node 'n2' to 600
$n2 set Y_ 600                        # Set the Y coordinate of node 'n2' to 600
$n2 set Z_ 0                          # Set the Z coordinate of node 'n2' to 0

$ns at 0.1 "$n0 setdest 50 50 15"      # Schedule an event at time 0.1 to set the destination of node 'n0' to (50, 50, 15)
$ns at 0.1 "$n1 setdest 100 100 25"    # Schedule an event at time 0.1 to set the destination of node 'n1' to (100, 100, 25)
$ns at 0.1 "$n2 setdest 600 600 25"    # Schedule an event at time 0.1 to set the destination of node 'n2' to (600, 600, 25)

set tcp0 [new Agent/TCP]               # Create a new TCP agent and assign it to the variable 'tcp0'
$ns attach-agent $n0 $tcp0             # Attach the TCP agent 'tcp0' to node 'n0'
set ftp0 [new Application/FTP]         # Create a new FTP application and assign it to the variable 'ftp0'
$ftp0 attach-agent $tcp0               # Attach the TCP agent 'tcp0' to the FTP application 'ftp0'
set sink1 [new Agent/TCPSink]          # Create a new TCP sink agent and assign it to the variable 'sink1'
$ns attach-agent $n1 $sink1            # Attach the TCP sink agent 'sink1' to node 'n1'
$ns connect $tcp0 $sink1               # Connect the TCP agent 'tcp0' to the TCP sink agent 'sink1'

set tcp1 [new Agent/TCP]               # Create a new TCP agent and assign it to the variable 'tcp1'
$ns attach-agent $n1 $tcp1             # Attach the TCP agent 'tcp1' to node 'n1'
set ftp1 [new Application/FTP]         # Create a new FTP application and assign it to the variable 'ftp1'
$ftp1 attach-agent $tcp1               # Attach the TCP agent 'tcp1' to the FTP application 'ftp1'
set sink2 [new Agent/TCPSink]          # Create a new TCP sink agent and assign it to the variable 'sink2'
$ns attach-agent $n2 $sink2            # Attach the TCP sink agent 'sink2' to node 'n2'
$ns connect $tcp1 $sink2               # Connect the TCP agent 'tcp1' to the TCP sink agent 'sink2'

$ns at 5 "$ftp0 start"                 # Schedule an event at time 5 to start the FTP application 'ftp0'
$ns at 5 "$ftp1 start"                 # Schedule an event at time 5 to start the FTP application 'ftp1'
$ns at 100 "$n1 setdest 550 550 15"    # Schedule an event at time 100 to set the destination of node 'n1' to (550, 550, 15)
$ns at 190 "$n1 setdest 70 70 15"      # Schedule an event at time 190 to set the destination of node 'n1' to (70, 70, 15)

proc finish { } {                      # Define a procedure named 'finish'
    global ns nf tf                    # Declare the variables 'ns', 'nf', and 'tf' as global
    $ns flush-trace                     # Flush the trace output to the file
    exec nam lab2.nam &                 # Execute the 'nam' command to open the network animator with the 'lab2.nam' file
    close $tf                           # Close the trace file
    exit 0                              # Exit the program
}

$ns at 250 "finish"                    # Schedule an event at time 250 to call the 'finish' procedure
$ns run                               # Run the simulation

# ns lab2.tcl - to run the file

# gedit lab2.awk - to open the file

BEGIN {
    count1 = 0;  # Initialize a variable 'count1' to 0
    count2 = 0;  # Initialize a variable 'count2' to 0
    pack1 = 0;   # Initialize a variable 'pack1' to 0
    pack2 = 0;   # Initialize a variable 'pack2' to 0
    time1 = 0;   # Initialize a variable 'time1' to 0
    time2 = 0;   # Initialize a variable 'time2' to 0
}
{
    if ($1 == "r" && $3 == "_1_" && $4 == "AGT") {  # $1 is the type of the packet, $3 is the source node, and $4 is the packet type (AGT for application data packet)
        count1++ ;  # Increment the value of 'count1' by 1
        pack1 = pack1 + $8 ;  # $8 is the size of the packet in bytes
        time1 = $2 ;  # $2 is the time at which the packet was received
    }
    if ($1 == "r" && $3 == "_2_" && $4 == "AGT") {  # $1 is the type of the packet, $3 is the source node, and $4 is the packet type (AGT for application data packet)
        count2++ ;  # Increment the value of 'count2' by 1
        pack2 = pack2 + $8 ;  # $8 is the size of the packet in bytes
        time2 = $2 ;  # $2 is the time at which the packet was received
    }
}
END {
    printf("The Throughput from n0 to n1: %f Mbps`n", ((count1 * pack1 * 8) / (time1 * 1000000))) ;  # Calculate and print the throughput from n0 to n1
    printf("The Throughput from n1 to n2: %f Mbps", ((count2 * pack2 * 8) / (time2 * 1000000))) ;  # Calculate and print the throughput from n1 to n2
}

# awk -f lab2.awk lab2.tr - to run the file