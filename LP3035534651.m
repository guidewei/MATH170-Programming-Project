%
% Part 1 of the MATH170 Programming Project
% This is an interactive program which can solve any given canonical form LP 
% based the revised simplex tableau program written by Prof. Ming Gu.
% Written by Mingyang Wei, SID: 3035534651
% April 2020
%

function [data, info] = LP3035534651(A, b, c)
%replace all elements of b with nonnegative
index_negative= find(b<0);
b(index_negative)=-1.*b(index_negative);
A(index_negative,:)=-1.*A(index_negative,:);

A_1=A;
b_1=b;
c_1=c;

[m, n]=size(A);
[m_b, n_b]=size(b);
[m_c, n_c]=size(c);
%check the input matrices' dimensional rationality
if m_b~=m
    info.run= "Failure";
    info.msg= "The input matrices' dimensions do not match!";
    data.run="Failure";
    return
else
end   

if m_c~=n
    info.run= "Failure";
    info.msg= "The input matrices' dimensions do not match!" ;
    data.run="Failure";
    return
else
end 

%check the assumptions of non-degeneracy;
%first, we assume that the m rows of A are linearly independent
if rank(A)~=m
    info.run= "Failure";
    info.msg= "Failure due to degeneracy (violate non-degeneracy assumptions(i))" ;
    data.run="Failure";
    return
else
end 

info.run="Success";
%Phase I: find basic feasible solution
%introduce slack variable
[m, n]=size(A);
x=[zeros(n,1);b];
A=[A,eye(m)];
c=[zeros(n,1);ones(m,1)];
[m, n]=size(A);
B=find(x>0);
T = A(:,B)\[b eye(m)];
y = T(:,2:end)'*c(B);
T = [T;[c'*x,y']];
%
% Starting Simplex Method
%
f = ['Starting Phase I Simplex Iteration... '];
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
       info.run="Failure";
       info.msg("Failure due to degeneracy (violate non-degeneracy assumptions(ii))");
       data.run="Failure";
       return;
       %continue;
   end
   if (r < 1)
       disp('LP has no lower bound');
       %in the PhaseI, the objective function must have the lower bound, 0.
       %thus this sentence is useless.
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
       info.run="Failure";
       info.msg("Failure due to degeneracy (violate non-degeneracy assumptions(ii))");
       data.run="Failure";
       return;
       %continue;
   end
   B   = B1;
   obj = obj1;
%   disp('Current Basis is');
%   disp(B');
%   pause(1);
end
clear B1 f obj1 t zmin

if c'*x~=0
    info.case=3;
    info.msg="By PhaseI, there is no basic feasible solution for this Linear Program.";
    info.PhaseI.loop=ITER;
    data.msg="We have no data output.";
    return
end

data.PhaseI.obj=c'*x;
data.PhaseI.x=x;
info.PhaseI.loop=ITER;

%Phase II: find optimal basic feasible solution
A=A_1;
b=b_1;
c=c_1;
[m, n]=size(A);
x=x(1:n,:);
B=find(x>0);
T = A(:,B)\[b eye(m)];
y = T(:,2:end)'*c(B);
T = [T;[c'*x,y']];

% Starting Simplex Method
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
       info.run="Failure";
       info.msg("Failure due to degeneracy (violate non-degeneracy assumptions(ii))");
       return
       %continue;
   end
   if (r < 1)
       disp('LP has no lower bound');
       simplex = 0;
       info.case=2;
       info.msg="LP is feasible without optimal feasible solution.";
       C=find(x>0);
       t_1=zeros(n,1);
       t_1(C)=t;
       data.PhaseII.x=x;
       data.PhaseII.t=t_1;
       info.PhaseII.loop=ITER;
       return
       %continue;
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
       info.run="Failure";
       info.msg("Failure due to degeneracy (violate non-degeneracy assumptions(ii))");
       return;
       %continue;
   end
   B   = B1;
   obj = obj1;
%   disp('Current Basis is');
%   disp(B');
%   pause(1);
end
clear B1 f obj1 t zmin

info.case=1;
%LP is feasible with optimal solution
data.PhaseII.Primalobj=c'*x;
data.PhaseII.Dualobj=b'*y;
data.PhaseII.x=x;
data.PhaseII.y=y;
data.PhaseII.z=c-A'*y;
info.PhaseII.loop=ITER;
end
