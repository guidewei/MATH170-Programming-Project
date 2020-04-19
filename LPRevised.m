%
% This is an interactive program demonstrating the Simplex Method 
% via the revised simplex tableau.
% Written by Ming Gu for Math 170
% March 2020
%

% input dimensions
%
m = input('How many constraints: ');
n = input('How many unknowns: ');
%
% setup LP
%
B =(1:m)';
A =rand(m,n);
x =zeros(n,1);
x(B)=rand(m,1);
b =A*x;
c =randn(n,1);
T = A(:,B)\[b eye(m)];
y = T(:,2:end)'*c(B);
T = [T;[c'*x,y']];
%
% Starting Simplex Method
%
f = ['Starting Phase II Simplex Iteration... '];
format short g;
disp(f);
%disp('Initial Basis is');
%disp(B');
obj = c'*x;
disp(['Initial Objective = ', num2str(obj)]);
%disp('Displaying Initial solution x, c-A^T*y and their componentwise product');
%disp([x c-A'*y x.*(c-A'*y)]);
simplex = 1;
ITER = 0;
%pause(2);
while (simplex == 1)
%
% determine the next s and r values.
%
   y        = T(end,2:end)';
   [zmin,s] = min(c-A'*y); 
%
% check for convergence.
%
   if (abs(zmin) < 1e-14)
       disp('Simplex Method has converged');
       simplex = 0;
%       disp('Displaying Optimal Basis');
%       disp(B');
       x   = zeros(n,1);
       x(B) = T(1:end-1,1);
       obj  = c'*x;
       disp(['Optimal Objective = ', num2str(obj),' after ', num2str(ITER), ' iterations']);
       disp('Displaying Optimal solution x, c-A^T*y and their componentwise product');
       disp([x c-A'*y x.*(c-A'*y)]);
       continue;
   end

   t        = T(1:end-1,2:end)*A(:,s);
   [flg,r] = Revisedgetr(n,s,B,T,t);
   if (flg == 1)
       disp('LP is degenerate');
       simplex = 0;
       continue;
   end
   if (r < 1)
       disp('LP has no lower bound');
       simplex = 0;
       continue;
   end
   x   = zeros(n,1);
   x(B)= T(1:end-1,1);
   ITER = ITER + 1;
   f = ['Iteration ', num2str(ITER), ' Obj ', num2str(c'*x), '. Smallest component in c-A^T*y: ', ... 
         num2str(zmin), ' at s =', num2str(s), '. Component r = ', num2str(r), ' out of basis'];
%   disp(f);
   obj1 = c'*x;
%
% update the revised simplex tableau.
%
   [T,B1,flg]=RevisedSimplexTableau(B,r,s,t,zmin,T);      
   if (flg == 1)
       disp('LP is degenerate');
       simplex = 0;
       continue;
   end
   B   = B1;
   obj = obj1;
%   disp('Current Basis is');
%   disp(B');
%   pause(1);
end
clear B1 f obj1 t zmin



