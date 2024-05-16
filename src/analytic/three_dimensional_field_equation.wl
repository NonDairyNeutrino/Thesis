(* ::Package:: *)

Clear@covariantMetric
MatrixForm[covariantMetric=(n0/c[t])^(2/(d-1))BlockDiagonalMatrix@{{{-c[t]^2}},IdentityMatrix@3}//Normal];
Clear@contravariantMetric;
MatrixForm[contravariantMetric=Inverse@covariantMetric]


Clear@metDet
metDet=Sqrt[-Det@covariantMetric]


1/metDet Sum[D[metDet contravariantMetric[[\[Mu]+1,\[Nu]+1]]D[\[Theta][t,x,y,z],{t,x,y,z}[[\[Nu]+1]]],{t,x,y,z}[[\[Mu]+1]]],{\[Mu],0,3},{\[Nu],0,3}]//FullSimplify[#,c[t]>0]&;
%/.{
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
MultilineFunction->None]\)[t,x,y,z]->HoldForm[\!\(
\*SubsuperscriptBox[\(\[Del]\), \({x, y, z}\), \(2\)]\[Theta]\)],
\!\(\*SuperscriptBox[\(\[Theta]\), 
TagBox[
RowBox[{"(", 
RowBox[{"p_", ",", "0", ",", "0", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[t,x,y,z]:>HoldForm[\!\(
\*SubscriptBox[\(\[PartialD]\), \({t, p}\)]\[Theta]\)],
n0->Subscript[n, 0],
c:>Function[t,Subscript[c, 0]Sqrt[b[t]]]
}//FullSimplify[#,b[t]>0]&;

-%/.d->{2,3}//FullSimplify//Expand//MapThread[Labeled[#1==0,#2,Left]&,{#,{"\nd = 2:","\nd = 3:"}}]&//Column//TraditionalForm

(-Subscript[n, 0]^2%%/.d->2//Expand@*FullSimplify)==0//TraditionalForm

(-Subscript[c, 0] Subscript[n, 0] Sqrt[b[t]]%%%/.d->3//Expand@*FullSimplify)==0//TraditionalForm


Clear@fieldEquation
fieldEquation=D[\[Theta][t,x,y,z],{t,2}]-b'[t]/b[t] D[\[Theta][t,x,y,z],{t,1}]-c[0]^2b[t]Laplacian[\[Theta][t,x,y,z],{x,y,z}]==0
