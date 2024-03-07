import java.util.Scanner;

public class LeakyBucket {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int drop = 0, psent, nsec, cap, pleft = 0, i, process;
        int inp[] = new int[25];
        System.out.println("Enter The Bucket Size:");
        cap = sc.nextInt();
        System.out.println("Enter The Operation Rate:");
        process = sc.nextInt();
        System.out.println("Enter The No. Of Seconds You Want To Stimulate:");
        nsec = sc.nextInt();
        for (i = 0; i < nsec; i++) {
            System.out.print("Enter The Size Of The Packet Entering At " + (i + 1) + " sec: ");
            inp[i] = sc.nextInt();
        }
        System.out.println("\nSecond | Packet Recieved | Packet Sent | Packet Left | Packet Dropped|\n");
        System.out.println("------------------------------------------------------------------------\n");
        for (i = 0; i < nsec; i++) { // Iterate over the number of seconds
            pleft += inp[i]; // Add the size of the packet received at the current second to the packets left
            if (pleft > cap) { // If the packets left exceed the bucket size
                drop = pleft - cap; // Calculate the number of packets to be dropped
                pleft = cap; // Set the packets left to the bucket size
            }
            System.out.print(i + 1); // Print the current second
            System.out.print("\t\t" + inp[i]); // Print the size of the packet received at the current second
            psent = Math.min(pleft, process); // Calculate the number of packets to be sent based on the packets left and the operation rate
            System.out.print("\t\t" + psent); // Print the number of packets sent
            pleft = pleft - psent; // Update the packets left after sending packets
            System.out.print("\t\t" + pleft); // Print the number of packets left
            System.out.print("\t\t" + drop); // Print the number of packets dropped
            drop = 0; // Reset the number of packets dropped to 0
            System.out.println(); // Move to the next line
        }
        for (; pleft != 0; i++) { // Continue iterating until packets left is not zero
            System.out.print(i + 1); // Print the current second
            System.out.print("\t\t0"); // Print 0 for packet received
            psent = Math.min(pleft, process); // Calculate the number of packets to be sent based on packets left and operation rate
            System.out.print("\t\t" + psent); // Print the number of packets sent
            pleft = pleft - psent; // Update packets left after sending packets
            System.out.print("\t\t" + pleft); // Print the number of packets left
            System.out.print("\t\t" + drop); // Print the number of packets dropped
            System.out.println(); // Move to the next line
        }
        sc.close();
    }

}
/* OUTPUT:

Enter The Bucket Size:
5
Enter The Operation Rate:
2
Enter The No. Of Seconds You Want To Stimulate:
4
Enter The Size Of The Packet Entering At 1 sec: 6
Enter The Size Of The Packet Entering At 2 sec: 2
Enter The Size Of The Packet Entering At 3 sec: 3
Enter The Size Of The Packet Entering At 4 sec: 4

Second | Packet Recieved | Packet Sent | Packet Left | Packet Dropped|

------------------------------------------------------------------------

1               6               2               3               1
2               2               2               3               0
3               3               2               3               1
4               4               2               3               2
5               0               2               1               0
6               0               1               0               0

 */