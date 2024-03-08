# gedit lab4.tcl - to open the file

'''
4. Implement transmission of ping messages/trace route 
over a network topology consisting of 6 nodes and find the number of packets dropped due to congestion.
'''

set ns [new Simulator]  # Create a new simulator object
set nf [open lab2.nam w]  # Open a file named "lab2.nam" in write mode and assign it to the variable nf
$ns namtrace-all $nf  # Enable nam tracing for all objects in the simulator and redirect the output to the file nf
set tf [open lab2.tr w]  # Open a file named "lab2.tr" in write mode and assign it to the variable tf
$ns trace-all $tf  # Enable tracing for all objects in the simulator and redirect the output to the file tf

set n0 [$ns node]  # Create a node object and assign it to the variable n0
set n1 [$ns node]  # Create a node object and assign it to the variable n1
set n2 [$ns node]  # Create a node object and assign it to the variable n2
set n3 [$ns node]  # Create a node object and assign it to the variable n3
set n4 [$ns node]  # Create a node object and assign it to the variable n4
set n5 [$ns node]  # Create a node object and assign it to the variable n5

$n4 shape box  # Set the shape of node n4 to "box"

$ns duplex-link $n0 $n4 1005Mb 1ms DropTail  # Create a duplex link between nodes n0 and n4 with a bandwidth of 1005Mb, delay of 1ms, and DropTail queue
$ns queue-limit $n0 $n4 5  # Set the queue limit between nodes n0 and n4 to 5 packets

$ns duplex-link $n1 $n4 50Mb 1ms DropTail  # Create a duplex link between nodes n1 and n4 with a bandwidth of 50Mb, delay of 1ms, and DropTail queue

$ns duplex-link $n2 $n4 2000Mb 1ms DropTail  # Create a duplex link between nodes n2 and n4 with a bandwidth of 2000Mb, delay of 1ms, and DropTail queue
$ns queue-limit $n2 $n4 3  # Set the queue limit between nodes n2 and n4 to 3 packets

$ns duplex-link $n3 $n4 200Mb 1ms DropTail  # Create a duplex link between nodes n3 and n4 with a bandwidth of 200Mb, delay of 1ms, and DropTail queue

$ns duplex-link $n4 $n5 1Mb 1ms DropTail  # Create a duplex link between nodes n4 and n5 with a bandwidth of 1Mb, delay of 1ms, and DropTail queue
$ns queue-limit $n4 $n5 2  # Set the queue limit between nodes n4 and n5 to 2 packets


# Ping means Packet Internet Groper, it is used to check the connectivity between two nodes
# It sends ICMP (Internet Control Message Protocol) echo request packets to the target host and waits for an ICMP echo reply
# If the target host is reachable, it sends an ICMP echo reply back to the source host
# If the target host is not reachable, it sends an ICMP destination unreachable message back to the source host

set p1 [new Agent/Ping]  # Create a new Ping agent object and assign it to the variable p1
$ns attach-agent $n0 $p1  # Attach agent p1 to node n0
$p1 set packetSize_ 50000  # Set the packet size of agent p1 to 50000 bytes
$p1 set interval_ 0.0001  # Set the interval between sending packets for agent p1 to 0.0001 seconds

set p2 [new Agent/Ping]  # Create a new Ping agent object and assign it to the variable p2
$ns attach-agent $n1 $p2  # Attach agent p2 to node n1

set p3 [new Agent/Ping]  # Create a new Ping agent object and assign it to the variable p3
$ns attach-agent $n2 $p3  # Attach agent p3 to node n2
$p3 set packetSize_ 30000  # Set the packet size of agent p3 to 30000 bytes
$p3 set interval_ 0.00001  # Set the interval between sending packets for agent p3 to 0.00001 seconds

set p4 [new Agent/Ping]  # Create a new Ping agent object and assign it to the variable p4
$ns attach-agent $n3 $p4  # Attach agent p4 to node n3

set p5 [new Agent/Ping]  # Create a new Ping agent object and assign it to the variable p5
$ns attach-agent $n5 $p5  # Attach agent p5 to node n5

Agent/Ping instproc recv {from rtt} {  # Define a method called "recv" for the Ping agent class, rtt is the round trip time
    $self instvar node_  # Access the "node_" instance variable of the agent object
    puts "node [$node_ id] received answer from $from with round trip time $rtt msec"  # Print a message indicating that a ping response was received
}

$ns connect $p1 $p5  # Connect agent p1 to agent p5
$ns connect $p3 $p4  # Connect agent p3 to agent p4

proc finish {} {  # Define a procedure called "finish"
    global ns nf tf  # Declare the variables ns, nf, and tf as global
    $ns flush-trace  # Flush the trace output
    close $nf  # Close the file nf
    close $tf  # Close the file tf
    exec nam lab2.nam &  # Execute the "nam" command to open the nam visualization tool with the file lab2.nam
    exit 0  # Exit the program with a status code of 0
}

for ($i = 0.1; $i <= 2.9; $i += 0.1) {
    $ns at $i "$p1 send"  # Schedule agent p1 to send a ping packet at time $i seconds
}

for ($i = 0.1; $i <= 2.9; $i += 0.1) {
    $ns at $i "$p3 send"  # Schedule agent p3 to send a ping packet at time $i seconds
}

$ns at 3.0 "finish"  # Schedule the "finish" procedure to be executed at time 3.0 seconds
$ns run  # Run the simulation

# ns lab2.tcl - to run the file

# gedit lab2.awk - to open the file

BEGIN {
    drop=0;
} 
{
    if($1= ="d" )
    {
        drop++;
    }
} 
END {
    printf("Total number of %s packets dropped due to congestion =%d\n",$5,drop); # $5 is the type of the packet
}

# awk -f lab2.awk lab2.tr - to run the file