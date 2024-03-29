import java.util.Scanner;

public class CRC {
    public static void main(String args[]){
        Scanner sc = new Scanner(System.in);
        int[] data;
        int[] div;
        int[] divisor;
        int[] rem;
        int[] crc;
        int data_bits, divisor_bits, tot_length;
        System.out.println("Enter number of data bits : ");
        data_bits = sc.nextInt();
        data = new int[data_bits];
        System.out.println("Enter data bits : ");
        for (int i = 0; i < data_bits; i++)
            data[i] = sc.nextInt();
        System.out.println("Enter number of bits in divisor : ");
        divisor_bits = sc.nextInt();
        divisor = new int[divisor_bits];
        System.out.println("Enter Divisor bits : ");
        for (int i = 0; i < divisor_bits; i++)
            divisor[i] = sc.nextInt();
        tot_length = data_bits + divisor_bits - 1;
        div = new int[tot_length];
        rem = new int[tot_length];
        crc = new int[tot_length];
        /*------------------ CRC GENERATION-----------------------*/ for (int i = 0; i < data.length; i++)
            div[i] = data[i];
        System.out.print("Dividend (after appending 0's) are : ");
        for (int i = 0; i < div.length; i++)
            System.out.print(div[i]);
        System.out.println();
        for (int j = 0; j < div.length; j++) {
            rem[j] = div[j];
        }
        rem = divide(div, divisor, rem);
        for (int i = 0; i < div.length; i++) // append dividend and ramainder
        {
            crc[i] = (div[i] ^ rem[i]);
        }
        System.out.println();
        System.out.println("CRC code : ");
        for (int i = 0; i < crc.length; i++)
            System.out.print(crc[i]);
        /*-------------------ERROR DETECTION---------------------*/
        System.out.println();
        System.out.println("Enter CRC code of " + tot_length + " bits : ");
        for (int i = 0; i < crc.length; i++)
            crc[i] = sc.nextInt();
        for (int j = 0; j < crc.length; j++) {
            rem[j] = crc[j];
        }
        rem = divide(crc, divisor, rem);
        for (int i = 0; i < rem.length; i++) {
            if (rem[i] != 0) {
                System.out.println("Error");
                break;
            }
            if (i == rem.length - 1)
                System.out.println("No Error");
        }
        System.out.println();
        sc.close();
    }

    static int[] divide(int div[], int divisor[], int rem[]) {
        int cur = 0;
        while (true) {
            for (int i = 0; i < divisor.length; i++)
                rem[cur + i] = (rem[cur + i] ^ divisor[i]);
            while (rem[cur] == 0 && cur != rem.length - 1)
                cur++;
            if ((rem.length - cur) < divisor.length)
                break;
        }
        return rem;
    }
}

/* OUTPUT:

Enter number of data bits : 
7
Enter data bits : 
1 0 1 1 0 0 1
Enter number of bits in divisor : 
3
Enter Divisor bits : 
1 0 1
Dividend (after appending 0's) are : 101100100

CRC code :
101100111
Enter CRC code of 9 bits :
1 0 1 1 0 0 1 0 1
Error


Enter number of data bits : 
7
Enter data bits : 
1 0 1 1 0 0 1
Enter number of bits in divisor : 
3
Enter Divisor bits : 
1 0 1
Dividend (after appending 0's) are : 101100100

CRC code :
101100111
Enter CRC code of 9 bits :
1 0 1 1 0 0 1 1 1
No Error

 */