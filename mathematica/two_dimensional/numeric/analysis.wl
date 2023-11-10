(* ::Package:: *)

SetDirectory@NotebookDirectory[];


Clear@parametersExplicit;
parametersExplicit = <|
	boxLength -> 10^1,
	m -> 1,
	hbar-> 1,
	initialParticleNumber -> 10^7,
	initialNonlinearity -> 10^5,
	nonDimTimeScale -> 5 10^-5,
	timeFinal -> 1 (*Normal@First@SolveValues[expansion[2,ts][tf]==expansionValue&&tf>0&&ts>0,tf]*),
	scalingFunction -> Function[{labTime, timeScale}, Exp[-labTime/timeScale]]
|>;


time = First@AbsoluteTiming[data = Table[
	parametersExplicit@boxLength = bL; {bL, First@<<"numeric_de_sitter.wl"},
	{bL, Outer[Times, PowerRange[10^2], Range[9]]//Catenate}
]]


SendMessage["SMS","Solutions took "<>ToString@time<>" seconds"]


ListLogLogPlot@Rest@data
