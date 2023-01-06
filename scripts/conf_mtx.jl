using Plots
using .MyPlots

Pred = [1,2,3,3,4,2]
Real = [1,2,3,3,3,3]

MyPlots.plot_confusion_matrix(Pred, Real, 4, ["flawless","drif","offset","outlier"])

