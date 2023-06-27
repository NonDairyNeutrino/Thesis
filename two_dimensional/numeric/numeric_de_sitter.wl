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
\[Theta][-2ts,x,y]==Exp@-(x^2+y^2)^2,
Derivative[1,0,0][\[Theta]][-2ts,x,y]==0
}/.{interactionStrength[0]->interactionStrength0,soundSpeed[0]->soundSpeed0}


phaseFieldSolution=NDSolveValue[
{
phaseFieldEquation,
initialConditionList
},
\[Theta],
{\[Eta],-2ts,0},
{x,y}\[Element]universe
]


phaseField = Table[phaseFieldSolution[\[Eta],x,y], {\[Eta], -2 ts, 0, 2 ts / 10}, {x, -boxLength/2, boxLength/2, boxLength/100}, {y, -boxLength/2, boxLength/2, boxLength/100}];


phaseFieldFourierAmplitude = Fourier[phaseField[[1]],{{2,2}}]
densityFieldFourierAmplitude = -(\[HBar] / interactionStrength0)(Fourier[phaseField[[2]],{{2,2}}]-Fourier[phaseField[[1]],{{2,2}}]) / (2 ts / 10)


mixedFourierAmplitude["u"] = 1 / (2Sqrt[n0]) densityFieldFourierAmplitude + I Sqrt[n0] phaseFieldFourierAmplitude
mixedFourierAmplitude["v"] = 1 / (2Sqrt[n0]) densityFieldFourierAmplitude - I Sqrt[n0] phaseFieldFourierAmplitude
