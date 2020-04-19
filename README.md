##### README for the MATH170 Programming Project

Name: Mingyang Wei

S. ID: 3035534651

- ###### Files in my repository

  - `Project.pdf`-requirement of MATH 170 Programming Project, 2020 Spring 2020
  - `The Cost of Subsistence.pdf`-original paper of George Stigler's Diet Problem
  - `LPRevised.m`-Prof. Gu's original code
  - `Revisedgetr.m`-see above
  - `RevisedSimplexTableau.m`-see above
  - `LP3035534651.m`-canonical LP solver function (<font color=red>my own Part I</font>)
  - `diet_problem.m`-solver of  Stigler's Diet Problem (<font color=red>my own Part II</font>)
  - `README.md`- a brief description of my programming project
  - `README.pdf`- PDF version of readme file
  - `Table_A.xlsx`- original data of Table_A in George Stigler's Paper

- ###### Part 1

  - The format of output `data` and `info` is struct;
  - for the case `info.run = "Failure"`, I define `data.run = "Failure"` to make sure that there exists output value for `data`;

  - for the non-degeneracy, I add a rank check to check whether the input matrices violates non degenerate assumption (i):

    - example

      $\rightarrow$ input:

      ```matlab
      A=[2,1,4;5,1,4;7,2,8];
      b=[1;3;5];
      c=[1;1;1];
      ```

      $\rightarrow$ partial output:

      ```matlab
      info.run
      
      ans = 
           "Failure"
      ```

      ```matlab
      info.msg
      
      ans =
           "Failure due to degeneracy (violate non-degeneracy assumptions(i))"
      ```

  - but for the non-degenerate assumption (ii), the original codes still work will when we input some obvious degenerate LP:

    - for example, if we input the following matrices:

      ```matlab
      A = [1,2,3;2,4,1];
      b = [6;2];
      c = [1; 1; -3];
      ```

      this is an obvious degenerate LP because $b=2a^{(3)}$ and $m=2$.

      But the partial output is:

      ```matlab
      data.PhaseII.Primalobj
      
      ans = 
           -6
      ```

      <font color=red>That's wired!</font>

    - At the first, I want to revise the current codes to make sure they can check non-degenerate assumption (ii) strictly. But then, I decide to just keep the current codes because they can solve some degenerate LP correctly implies our algorithms are more adaptable than we think! It's reasonable to keep the advantage of our algorithms.

  - for the `data.PhaseI.x`, the output I choose is a $m+n$ dimensions columns vector with $m$ 0 at the end. If you want to output a $n$ dimensions columns vector (the exact basic feasible solution of the given LP), you can add 

    ```matlab
    x=x(1:n,:); 
    ```

    before this line;

  - I don't display any outputs in the command window, that because I want to make the command window super clean and just display Prof. Gu's original information.

- ###### Part 2

  - The George Stigler's Diet Problem is a standard form LP, that because the constraints is 
    $$
    \text{min} \ c^Tx\\s.t.\ Ax\geqslant b\\\quad \quad \quad x\geqslant0
    $$
    which implies before we use the function given in the Part 2, we should introduce slack variables vector and restate the diet problem into a canonical form.

    

  - After that, we can obtain the matrices $A$, $b$ and $c$ easily with some steps of simple handling.

  - Display some outputs:

    ```matlab
    data.PhaseII
    
    ans = 
    
        Primalobj: 0.10866
          Dualobj: 0.10866
                x: [86×1 double]
                y: [9×1 double]
                z: [86×1 double]
    ```

    which shows that the optimal daily cost is <font color=red>$\$$0.10866</font>. The optimal basic solution $x^*$ is a $77\times1$ dimensional column vector, and shown below:

    ```matlab
    the opimal daily consumption vector is:
        "The optimal daily consumption of Wheat Flour is 371.9402g."
        "The optimal daily consumption of Liver is 3.202207g."
        "The optimal daily consumption of Cabbage is 100.358g."
        "The optimal daily consumption of Spinach is 22.99518g."
        "The optimal daily consumption of Navy Beans, Dried is 469.1876g."
    ```
    
    ```matlab
    
    the opimal daily intake is:
        "The intake of Calories is 3kcal, and the lower bound of daily intake is 3kcal."
        "The intake of Protein is 147.4135g, and the lower bound of daily intake is 70g."
        "The intake of Calcium is 0.8g, and the lower bound of daily intake is 0.8g."
        "The intake of Iron is 60.46692mg, and the lower bound of daily intake is 12mg."
        "The intake of Vitamin A is 5kIU, and the lower bound of daily intake is 5kIU."
        "The intake of Thiamine is 4.120439mg, and the lower bound of daily intake is 1.8mg."
        "The intake of Riboflavin is 2.7mg, and the lower bound of daily intake is 2.7mg."
        "The intake of Niacin is 27.31598mg, and the lower bound of daily intake is 18mg."
        "The intake of Ascorbic Acid is 75mg, and the lower bound of daily intake is 75mg."
    ```
    
    ```matlab
    the opimal daily cost is:
        "0.10866 dollar"
    ```

- ###### In the end

  - Thanks for the dedication of Prof. Ming Gu and our GSI Jiaming Want this semester. In this special time, I hope every one will stay safe and the epidemic of COVID-19 will end soon.
  - :link:github link of this repository: https://github.com/guidewei/MATH170-Programming-Project

*last update: April 19, 2020*