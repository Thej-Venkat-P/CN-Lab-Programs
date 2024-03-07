# gedit lab6.tcl - to open the file

'''
6. Implement an Ethernet LAN using n nodes 
and set multiple traffic nodes and plot congestion window for different source / destination.
'''


# Create a new simulator object
set ns [new Simulator]

# Open a file for tracing
set tf [open lab6.tr w]
$ns trace-all $tf

# Open a file for network animation
set nf [open lab6.nam w]
$ns namtrace-all $nf

# Create nodes in the network
set n0 [$ns node]
$n0 color "magenta"
$n0 label "src1"

set n1 [$ns node]

set n2 [$ns node]
$n2 color "magenta"
$n2 label "src2"

set n3 [$ns node]
$n3 color "blue"
$n3 label "dest2"

set n4 [$ns node]

set n5 [$ns node]
$n5 color "blue"
$n5 label "dest1"

# Create a LAN with the specified nodes and parameters
$ns make-lan "$n0 $n1 $n2 $n3 $n4" 100Mb 100ms LL Queue/DropTail Mac/802_3

# Create a duplex link between n4 and n5
$ns duplex-link $n4 $n5 1Mb 1ms DropTail

# Create TCP agent and attach it to n0
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

# Create FTP application and attach it to tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.0001

# Create TCP sink agent and attach it to n5
set sink5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink5
$ns connect $tcp0 $sink5

# Create another TCP agent and attach it to n2
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

# Create another FTP application and attach it to tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set packetSize_ 600
$ftp2 set interval_ 0.001

# Create another TCP sink agent and attach it to n3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp2 $sink3

# Open a file for tracing cwnd values of tcp0
set file1 [open file1.tr w]
$tcp0 attach $file1

# Open a file for tracing cwnd values of tcp2
set file2 [open file2.tr w]
$tcp2 attach $file2

# Trace congestion window values of tcp0
$tcp0 trace cwnd_

# Trace congestion window values of tcp2
$tcp2 trace cwnd_

# Define a procedure to be executed at the end of simulation
proc finish { } {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec nam lab6.nam &
    exit 0
}

# Schedule events for starting and stopping FTP transfers
$ns at 0.1 "$ftp0 start"
$ns at 5 "$ftp0 stop"
$ns at 7 "$ftp0 start"
$ns at 0.2 "$ftp2 start"
$ns at 8 "$ftp2 stop"
$ns at 14 "$ftp0 stop"
$ns at 10 "$ftp2 start"
$ns at 15 "$ftp2 stop"
$ns at 16 "finish"

# Run the simulation
$ns run

# ns lab6.tcl - to run the file

# gedit lab6.awk - to open the file

BEGIN {
}
{
if($6=="cwnd_") # don’t leave space after writing cwnd_
    printf("%f\t%f\t\n",$1,$7); # $1 is time and $7 is cwnd which represents congestion window
}
END {
}

# awk -f lab6.awk file1.tr > a1
# awk -f lab6.awk file2.tr > a2
# xgraph a1 a2 - to plot the congestion window for different source / destination