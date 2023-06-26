(* ::Package:: *)

Clear@"Global`*"


(* ::Text:: *)
(*Start with numeric parameters*)


boxLength=10;
universe=Cuboid[-0.5{boxLength,boxLength},0.5{boxLength,boxLength}];
m=1;
\[HBar]=1;
n0=10^7;
initialNonlinearity=10^5;
(*expansionValue=2000;*)
nonDimTimeScale=5 10^-5;

ts=nonDimTimeScale (m boxLength^2)/\[HBar];
interactionStrength0=initialNonlinearity \[HBar]^2/(n0 m boxLength^2);
soundSpeed0=Sqrt@initialNonlinearity;
tf=1(*Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf];*);


(* ::Text:: *)
(*Define quantities*)


Clear@scaling
(*eq 100 b[t] de Sitter*)scaling["Lab",timeScale_][labTime_]:=Exp[-labTime/timeScale]
scaling["conformal",timeScale_][\[Eta]_]:=(\[Eta]/(2timeScale))^2


(* ::Text:: *)
(*Define the field equation*)


Clear[phaseFieldEquation,initialConditionList]
phaseFieldEquation=D[\[Theta][\[Eta],x,y],{\[Eta],2}]-1/2 b'[\[Eta]]/b[\[Eta]] D[\[Theta][\[Eta],x,y],{\[Eta],1}]-soundSpeed0^2Laplacian[\[Theta][\[Eta],x,y],{x,y}]==0/.b->scaling["conformal",ts]//Expand
initialConditionList=Splice@{
\[Theta][-2ts,x,y]==(x^2+y^2)^2,
Derivative[1,0,0][\[Theta]][-2ts,x,y]==0
}/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0}


phaseFieldSolution=NDSolveValue[
{
phaseFieldEquation,
initialConditionList
},
\[Theta],
{\[Eta],-2ts,0},
{x,y}\[Element]universe,
InterpolationOrder->All
]


Manipulate[
ContourPlot[phaseFieldSolution[\[Eta],x,y],{x,y}\[Element]universe,PlotPoints->100],
{\[Eta],-2ts,0,Animator}
]
