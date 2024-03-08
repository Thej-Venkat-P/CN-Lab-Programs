# gedit lab1.tcl - to open the file

''' 
1. Implement  Three  nodes  point  –  to  –  point  network  with  duplex  links  between  them 
for different topologies. Set the queue size, vary the bandwidth, and find the number 
of packets dropped for various iterations.
'''

set ns [new Simulator]		# Create a new simulator object and assign it to the variable 'ns'
set nf [open lab1.nam w]	# Open a file named 'lab1.nam' in write mode and assign the file handle to the variable 'nf'
$ns namtrace-all $nf		# Enable nam tracing for all objects in the simulator and redirect the output to the 'lab1.nam' file
set tf [open lab1.tr w]		# Open a file named 'lab1.tr' in write mode and assign the file handle to the variable 'tf'
$ns trace-all $tf			# Enable tracing for all objects in the simulator and redirect the output to the 'lab1.tr' file

proc finish { } {			# Define a procedure named 'finish'
    global ns nf tf			# Declare the variables 'ns', 'nf', and 'tf' as global within the procedure
    $ns flush-trace			# Flush any remaining trace data to the output files
    close $nf				# Close the 'lab1.nam' file
    close $tf				# Close the 'lab1.tr' file
    exec nam lab1.nam &		# Execute the 'nam' command to open the 'lab1.nam' file in the Network Animator tool
    exit 0					# Exit the Tcl interpreter with a status code of 0
}

set n0 [$ns node]			# Create a new node object and assign it to the variable 'n0'
set n1 [$ns node]			# Create a new node object and assign it to the variable 'n1'
set n2 [$ns node]			# Create a new node object and assign it to the variable 'n2'
set n3 [$ns node]			# Create a new node object and assign it to the variable 'n3'

$ns duplex-link $n0 $n2 200Mb 10ms DropTail		# Create a duplex link between nodes 'n0' and 'n2' with a bandwidth of 200Mb and a delay of 10ms using the DropTail queueing discipline
$ns duplex-link $n1 $n2 100Mb 5ms DropTail		# Create a duplex link between nodes 'n1' and 'n2' with a bandwidth of 100Mb and a delay of 5ms using the DropTail queueing discipline
$ns duplex-link $n2 $n3 1Mb 1000ms DropTail		# Create a duplex link between nodes 'n2' and 'n3' with a bandwidth of 1Mb and a delay of 1000ms using the DropTail queueing discipline

$ns queue-limit $n0 $n2 10		# Set the queue limit for the link between nodes 'n0' and 'n2' to 10 packets
$ns queue-limit $n1 $n2 10		# Set the queue limit for the link between nodes 'n1' and 'n2' to 10 packets

set udp0 [new Agent/UDP]		# Create a new UDP agent object and assign it to the variable 'udp0'
$ns attach-agent $n0 $udp0		# Attach the UDP agent 'udp0' to node 'n0'
set cbr0 [new Application/Traffic/CBR]		# Create a new CBR traffic application object and assign it to the variable 'cbr0'
$cbr0 set packetSize_ 500		# Set the packet size of 'cbr0' to 500 bytes
$cbr0 set interval_ 0.005		# Set the interval between packets of 'cbr0' to 0.005 seconds
$cbr0 attach-agent $udp0		# Attach the UDP agent 'udp0' to the CBR traffic application 'cbr0'
# cbr full form is constant bit rate

set udp1 [new Agent/UDP]		# Create a new UDP agent object and assign it to the variable 'udp1'
$ns attach-agent $n1 $udp1		# Attach the UDP agent 'udp1' to node 'n1'
set cbr1 [new Application/Traffic/CBR]		# Create a new CBR traffic application object and assign it to the variable 'cbr1'
$cbr1 attach-agent $udp1		# Attach the UDP agent 'udp1' to the CBR traffic application 'cbr1'

set udp2 [new Agent/UDP]		# Create a new UDP agent object and assign it to the variable 'udp2'
$ns attach-agent $n2 $udp2		# Attach the UDP agent 'udp2' to node 'n2'
set cbr2 [new Application/Traffic/CBR]		# Create a new CBR traffic application object and assign it to the variable 'cbr2'
$cbr2 attach-agent $udp2		# Attach the UDP agent 'udp2' to the CBR traffic application 'cbr2'

set null0 [new Agent/Null]		# Create a new Null agent object and assign it to the variable 'null0'
$ns attach-agent $n3 $null0		# Attach the Null agent 'null0' to node 'n3'

$ns connect $udp0 $null0		# Connect the UDP agent 'udp0' to the Null agent 'null0'
$ns connect $udp1 $null0		# Connect the UDP agent 'udp1' to the Null agent 'null0'

$ns at 0.1 "$cbr0 start"		# Schedule the CBR traffic application 'cbr0' to start sending packets at time 0.1 seconds
$ns at 0.2 "$cbr1 start"		# Schedule the CBR traffic application 'cbr1' to start sending packets at time 0.2 seconds
$ns at 1.0 "finish"				# Schedule the 'finish' procedure to be executed at time 1.0 second
$ns run						# Run the simulation

# ns lab1.tcl - to run the file

# gedit lab1.awk - to open the file

BEGIN { 
    c=0;    # Initialize a variable 'c' to 0
}  
{  
    if ($1 == "d")  {    # If the type of the packet is 'd' (i.e., the packet is dropped)
        c++;    # Increment the value of count by 1
        printf("%s\t",$5);    # The 5th field is the time at which the packet was dropped.
        printf("%s\n",$11);    # The 11th field is the size of the packet
    }  
}  
END {  
    printf("The number of packets dropped = %d\n",c);    # Print the value of 'c' as the number of packets dropped
} 

# awk -f lab1.awk lab1.tr - to run the file