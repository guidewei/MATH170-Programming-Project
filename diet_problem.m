%
% Part 2 of the MATH170 Programming Project
%this file is to define the matrices of diet problem and find the optimal
%solution/objection value of it
% Written by Mingyang Wei, SID: 3035534651
% April 2020
%
clear;
clc;

%we can get the column vector b from Table 1 directly
b=[3000;70;0.8;12;5000;1.8;2.7;18;75];

%then, we can get matrix A and cost vector c from Table A
%first, import the "Table_A.xlsx" in the folder
Table_A=xlsread("Table_A.xlsx");
%"Table_A.xlsx" is original table in the paper and I just replaced all missing
%values with "0".
% The first column "Unit" is redundant, so I ignore the first column in the
% "Table_A.xlsx".

%to obtain the we should multiply 1,000 to the 3rd column (Calories) and
%7th column (Vitamin A)
Table_A(:,2)=1000*Table_A(:,2);
Table_A(:,6)=1000*Table_A(:,6);
mass=Table_A(:,1);
A_T=Table_A(:,2:end)./mass;
A=A_T';
c=1./Table_A(:,1);

%then restate the diet problem into the conanical form
[m,n]=size(A);
%introduce slack variables vector z
A=[A, -eye(m)];
c=[c;zeros(m,1)];
[data, info] = LP3035534651(A, b, c);
%please note that the data.PhaseII.x is the optimal vector x with optimal
%slack variables vector z. I will drop the vector in the following display
%process.

%now make the output cleaner
nutrients = ["Calories ","Protein ","Calcium ","Iron ","Vitamin A ","Thiamine ","Riboflavin ","Niacin ","Ascorbic Acid "];
commodities = ["Wheat Flour","Macaroni","Wheat Cereal","Corn Flakes","Corn Meal","Hominy Grits","Rice","Rolled Oats","White Bread","Whole Wheat Bread","Rye Bread","Pound Cake","Soda Crackers","Milk","Evaporated Milk","Butter","Oleomargarine","Eggs","Cheese","Cream","Peanut Butter","Mayonnaise","Crisco","Lard","Sirloin Steak","Round Steak","Rib Roast","Chuck Roast","Plate","Liver","Leg of Lamb","Lamb Chops","Pork Chops","Pork Loin Roast","Bacon","Ham-smoked","Salt Pork","Roasting Chicken","Veal Cutlets","Salmon, Pink","Appled","Bananas","Lemons","Oranges","Green Beans","Cabbage","Carrots","Celery","Lettuce","Onions","Potatoes","Spinach","Sweet Potatoes","Peaches","Pears","Pineapple","Asparagus","Green Beans","Pork and Beans","Corn","Peas","Tomatoes","Tomato Soup","Peaches, Dried","Prunes, Dried","Raisins, Dried","Peas, Dried","Lima Beans, Dried","Navy Beans, Dried","Coffee","Tea","Cocoa","Chocolate","Sugar","Corn Sirup","Molasses","Strawberry Preserves"];
optimal_vector=data.PhaseII.x;
optimal_vector=optimal_vector(1:77,1);
Find=find(optimal_vector);
optimal_vector=optimal_vector(Find);
commodities=commodities';
nutrients=nutrients';
commodities=commodities(Find,1);
A_bar=A(:,Find);
b_bar=A_bar*optimal_vector;
b_bar(1)=b_bar(1)./1000;
b_bar(5)=b_bar(5)./1000;

b_bar=num2str(b_bar);
b_bar=string(b_bar);
b_bar=strtrim(b_bar);
optimal_vector=num2str(optimal_vector);
optimal_vector=string(optimal_vector);
optimal_vector=strtrim(optimal_vector);
is_1=[" is ";" is ";" is ";" is ";" is "];
g=["g.";"g.";"g.";"g.";"g."];
con=["The optimal daily consumption of ";"The optimal daily consumption of ";"The optimal daily consumption of ";"The optimal daily consumption of ";"The optimal daily consumption of "];
disp("the opimal daily consumption vector is:");
disp(con+commodities+is_1+optimal_vector+g);

disp("the opimal daily intake is:");
Ingest=["The intake of "; "The intake of "; "The intake of "; "The intake of "; "The intake of "; "The intake of "; "The intake of "; "The intake of "; "The intake of "];
unit1=["kcal"; "g"; "g"; "mg"; "kIU"; "mg"; "mg"; "mg"; "mg"];
unit2=["kcal."; "g."; "g."; "mg."; "kIU."; "mg."; "mg."; "mg."; "mg."];
min=[", and the lower bound of daily intake is "];
is_2=["is ";"is ";"is ";"is ";"is ";"is ";"is ";"is ";"is "];
b(1)=b(1)./1000;
b(5)=b(5)./1000;
disp(Ingest+nutrients+is_2+b_bar+unit1+min+b+unit2);

disp("the opimal daily cost is:");
cost_per_year=data.PhaseII.Primalobj.*365;
Primalobj_char=num2str(data.PhaseII.Primalobj);
cost_per_year=num2str(cost_per_year);
char=[Primalobj_char+" dollar";"That implies for the whole year, your minimum cost on diet is "+cost_per_year+" dollar.";"It's really a amazing result that it cost so little if you just want to survive in that age."];
disp(char);