%Let's assume model accuracy and how sure it is be defined by the variable x
% be presented as [digit,acc,sureness] = model
%then we need to find such a function that will boost high accuracy and
%high sureness models to our voting system 
%then each model votes for one of the digit and the score of the vote
%is the function y. We choose the digit where y is the highest
x = linspace(0,1)
y = exp(1./sqrt(1-x))
semilogy(x,y)