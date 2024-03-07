// 5. Write a program to find the shortest path between vertices using bellman-ford algorithm.

import java.util.Scanner;

public class BellmanFord {
    private int D[];
    private int n;
    public static final int MAX_VALUE = 999;

    public BellmanFord(int n) {
        this.n = n;
        D = new int[n + 1];
    }

    public void shortest(int s, int A[][]) {
        for (int i = 1; i <= n; i++)
            D[i] = MAX_VALUE;
        D[s] = 0;

        for (int k = 1; k <= n - 1; k++) // Iterate n-1 times
            for (int i = 1; i <= n; i++) // Iterate over all vertices
                for (int j = 1; j <= n; j++) // Iterate over all vertices
                    if (D[j] > D[i] + A[i][j]) // If there is a shorter path from s to j through i
                        D[j] = D[i] + A[i][j]; // Update the shortest distance from s to j

        for (int i = 1; i <= n; i++)
            System.out.println("Distance of source " + s + " to " + i + " is " + D[i]);
    }

    public static void main(String[] args) {
        int n = 0, s;
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the number of vertices");
        n = sc.nextInt();
        int A[][] = new int[n + 1][n + 1];
        System.out.println("Enter the Weighted matrix");
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= n; j++) {
                A[i][j] = sc.nextInt();
                if (i == j) {
                    A[i][j] = 0;
                    continue;
                }
            }
        System.out.println("Enter the source vertex");
        s = sc.nextInt();
        BellmanFord b = new BellmanFord(n);
        b.shortest(s, A);
        sc.close();
    }
}

/* OUTPUT:

Enter the number of vertices
4
Enter the Weighted matrix
0 3 999 10
3 0 999 4  
999 999 0 5
10 4 5 0   
Enter the source vertex
2
Distance of source 2 to 1 is 3
Distance of source 2 to 2 is 0
Distance of source 2 to 3 is 9
Distance of source 2 to 4 is 4

 */