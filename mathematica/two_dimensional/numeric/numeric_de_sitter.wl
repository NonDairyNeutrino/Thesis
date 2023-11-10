(* ::Package:: *)

Clear@"Global`*"


(* ::Text:: *)
(*Start with numeric parameters*)


(*parametersExplicit = <|
	boxLength -> 10^2,
	m -> 1,
	hbar-> 1,
	initialParticleNumber -> 10^7,
	initialNonlinearity -> 10^5,
	nonDimTimeScale -> 5 10^-5,
	timeFinal -> 1 (*Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf]*),
	scalingFunction -> Function[{labTime, timeScale}, Exp[-labTime/timeScale]]
|>;*)


parametersImplicit = <|
	universe -> Cuboid[-0.5 parametersExplicit@boxLength {1,1}, 0.5 parametersExplicit[boxLength]{1,1}],
	timeScale -> parametersExplicit@nonDimTimeScale (parametersExplicit@m parametersExplicit@boxLength^2) / parametersExplicit@hbar,
	interactionStrength0 -> parametersExplicit@initialNonlinearity parametersExplicit@hbar^2/(parametersExplicit@initialParticleNumber parametersExplicit@m parametersExplicit@boxLength^2),
	soundSpeed0 -> Sqrt@parametersExplicit@initialNonlinearity
|>;


(* ::Text:: *)
(*Define quantities*)


Clear@scaling
(*eq 100 b[t] de Sitter*)scaling["Lab",timeScale_][labTime_]:= parametersExplicit[scalingFunction][labTime,timeScale]
scaling["conformal",timeScale_][\[Eta]_]:=(\[Eta]/(2 timeScale))^2


(* ::Text:: *)
(*Define the field equation*)


Clear[phaseFieldEquation,initialConditionList]
phaseFieldEquation=D[\[Theta][\[Eta],x,y],{\[Eta],2}]-1/2 b'[\[Eta]]/b[\[Eta]] D[\[Theta][\[Eta],x,y],{\[Eta],1}]-parametersImplicit@soundSpeed0^2Laplacian[\[Theta][\[Eta],x,y],{x,y}]==0/.b->scaling["conformal", parametersImplicit@timeScale]//Expand
initialConditionList=Splice@{
	\[Theta][-2 parametersImplicit@timeScale,x,y]==Exp@-(x^2+y^2)^2,
	Derivative[1,0,0][\[Theta]][-2 parametersImplicit@timeScale,x,y]==0
}/.{interactionStrength[0]->parametersImplicit@interactionStrength0,soundSpeed[0]->parametersImplicit@soundSpeed0}


phaseFieldSolution=NDSolveValue[
	{
		phaseFieldEquation,
		initialConditionList
	},
	\[Theta],
	{\[Eta], -2 parametersImplicit@timeScale, 0},
	{x, y} \[Element] parametersImplicit@universe
]


phaseField = Table[phaseFieldSolution[\[Eta],x,y], {\[Eta], -2 parametersImplicit@timeScale, 0, 2 parametersImplicit@timeScale / 10}, {x, -parametersExplicit@boxLength/2, parametersExplicit@boxLength/2, parametersExplicit@boxLength/100}, {y, -parametersExplicit@boxLength/2, parametersExplicit@boxLength/2, parametersExplicit@boxLength/100}];


waveVector = {1,1} + 1;
phaseFieldFourierAmplitude[0] = Fourier[phaseField[[1]],{waveVector}]
phaseFieldFourierAmplitude[\[Eta]] = Fourier[phaseField[[2]],{waveVector}]
densityFieldFourierAmplitude[0] = -(parametersExplicit@hbar / parametersImplicit@interactionStrength0)(phaseFieldFourierAmplitude[\[Eta]] - phaseFieldFourierAmplitude[0]) / (2 parametersImplicit@timeScale / 10)
densityFieldFourierAmplitude[\[Eta]] = -(parametersExplicit@hbar / parametersImplicit@interactionStrength0)(phaseFieldFourierAmplitude[\[Eta]] - phaseFieldFourierAmplitude[0]) / (2 parametersImplicit@timeScale / 10)


mixedFourierAmplitude["u","out"] = 1 / (2 Sqrt[parametersExplicit@initialParticleNumber]) densityFieldFourierAmplitude[0] + I Sqrt[parametersExplicit@initialParticleNumber] phaseFieldFourierAmplitude[0]
mixedFourierAmplitude["v","out"] = 1 / (2 Sqrt[parametersExplicit@initialParticleNumber]) densityFieldFourierAmplitude[0] - I Sqrt[parametersExplicit@initialParticleNumber] phaseFieldFourierAmplitude[0]


mixedFourierAmplitude["u","exp"] = 1 / (2 Sqrt[parametersExplicit@initialParticleNumber]) densityFieldFourierAmplitude[\[Eta]] + I Sqrt[parametersExplicit@initialParticleNumber] phaseFieldFourierAmplitude[\[Eta]]
mixedFourierAmplitude["v","exp"] = 1 / (2 Sqrt[parametersExplicit@initialParticleNumber]) densityFieldFourierAmplitude[\[Eta]] - I Sqrt[parametersExplicit@initialParticleNumber] phaseFieldFourierAmplitude[\[Eta]]


particleNumber = Conjugate@mixedFourierAmplitude["u","out"] Conjugate@mixedFourierAmplitude["v","exp"] - Conjugate@mixedFourierAmplitude["v","out"] Conjugate@mixedFourierAmplitude["u","exp"] // Abs[#]^2 &
