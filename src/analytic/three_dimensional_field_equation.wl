(* ::Package:: *)

(* ::Title:: *)
(*Deriving the Field Equation*)


(* ::Section::Closed:: *)
(*The General Metric*)


Clear@covariantMetric
MatrixForm[covariantMetric=(n0/c[t])^(2/(d-1))BlockDiagonalMatrix@{{{-c[t]^2}},IdentityMatrix@3}//Normal];
Clear@contravariantMetric;
MatrixForm[contravariantMetric=Inverse@covariantMetric]


Clear@metDet
metDet=Sqrt[-Det@covariantMetric]


(* ::Section::Closed:: *)
(*The Field Equation in Arbitrary Dimensions*)


Clear@fieldEquation
fieldEquation[d_] = (1/metDet) Sum[D[metDet contravariantMetric[[\[Mu]+1,\[Nu]+1]]D[\[Theta][t,x,y,z],{t,x,y,z}[[\[Nu]+1]]],{t,x,y,z}[[\[Mu]+1]]],{\[Mu],0,3},{\[Nu],0,3}] // FullSimplify[#,c[t]>0]&;

(*compactify the above with notation*)
fieldEquationNotated[d_] = fieldEquation[d] /. {
\!\(\*SuperscriptBox[\(\[Theta]\), 
TagBox[
RowBox[{"(", 
RowBox[{"0", ",", "0", ",", "0", ",", "2"}], ")"}],
Derivative],
MultilineFunction->None]\)[t,x,y,z]+\!\(\*SuperscriptBox[\(\[Theta]\), 
TagBox[
RowBox[{"(", 
RowBox[{"0", ",", "0", ",", "2", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[t,x,y,z]+\!\(\*SuperscriptBox[\(\[Theta]\), 
TagBox[
RowBox[{"(", 
RowBox[{"0", ",", "2", ",", "0", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[t,x,y,z]->HoldForm[Laplacian[\[Theta][t,x,y,z],{x,y,z}]],
\!\(\*SuperscriptBox[\(\[Theta]\), 
TagBox[
RowBox[{"(", 
RowBox[{"p_", ",", "0", ",", "0", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[t,x,y,z]:>HoldForm[D[\[Theta][t,x,y,z],{t,p}]],
n0->Subscript[n, 0],
c:>Function[t,Subscript[c, 0]Sqrt[a[t]]]
}/.\[Theta][__] -> \[Theta] // FullSimplify[#, a[t] > 0]&


(* ::Section:: *)
(*The Field Equation in 2 and 3 Dimensions*)


(*-fieldEquationNotated[{2,3}]//FullSimplify//Expand//MapThread[Labeled[#1==0,#2,Left]&,{#,{"\nd = 2:","\nd = 3:"}}]&//Column//TraditionalForm*)


(* ::Subsection:: *)
(*The 2 Dimensional Field Equation in Lab Time*)


(*Multiply by factors on both sides to simplify fractions*)
-Subscript[n, 0]^2 fieldEquationNotated[2]==0 // TraditionalForm@*Simplify
(* Substitute the phase \[Theta] for its Fourier Transform \[Theta]F*)
% /. {HoldForm[Laplacian[\[Theta], {x,y,z}]] -> k^2 \[Theta]F, \[Theta] -> \[Theta]F} // TraditionalForm


(* ::Subsection:: *)
(*The 3 Dimensional Field Equation in Lab Time*)


(*Multiply by factors on both sides to simplify fractions*)
(-Subscript[c, 0] Subscript[n, 0] Sqrt[a[t]] fieldEquationNotated[3]) == 0 // TraditionalForm@*Simplify
(* Substitute the phase \[Theta] for its Fourier Transform \[Theta]F*)
% /. {HoldForm[Laplacian[\[Theta], {x,y,z}]] -> k^2 \[Theta]F, \[Theta] -> \[Theta]F} // Simplify@*TraditionalForm
