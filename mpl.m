function [testclass, t, wHidden, wOutput] = mlp(traindata, trainclass, testdata, maxEpochs)
% Template for implementing a shallow multilayer perceptron network

N = size(traindata, 2);
d = size(traindata, 1);
classes = max(trainclass);

if ~exist('maxEpochs', 'var')
  maxEpochs = 100000;
end

% Initialisation
hidden = 3; % number of hidden layer neurons
J = zeros(1,maxEpochs); % loss function value vector initialisation
rho = 0.0001; % learning rate

trainOutput = zeros(classes, N);
for i = 1:N
  trainOutput(trainclass(i), i) = 1;
end

extendedInput = [traindata; ones(1, N)];
wHidden = (rand(d+1, hidden)-0.5) / 10;
wOutput = (rand(hidden+1, classes)-0.5) / 10;

fh1 = figure;
t = 0;
while 1 % iterative training "forever"
  t = t+1;
  
  % Feed-forward operation
  vHidden = wHidden' * extendedInput; % hidden layer net activation
  yHidden = tanh(vHidden); % hidden layer activation function

  yHidden = [yHidden; ones(1,N)]; % hidden layer extended output

  vOutput = wOutput' * yHidden; % output layer net activation
  yOutput = vOutput; % output layer output without activation f
    
  J(t) = 0.5 * sum(sum((yOutput - trainOutput) .^ 2)); % loss function evaluation

  if (mod(t, 1000) == 0) % Plot training error, but not for every epoch
    semilogy(1:t, J(1:t));
    title(sprintf('Training (epoch %d)', t));
    ylabel('Training error');
    
    drawnow;
  end
  
  if (J(t)<1e-12) % the learning is good enough
    break;
  end
  
  if (t>maxEpochs) % too many epochs would be done
    break;
  end
  
  if t > 1 % this is not the first epoch
    if (abs(J(t)-J(t-1)) < 1e-12) % the improvement is small enough
      break;
    end
  end
  
  % Update the sensitivities and the weights
  deltaOutput = (yOutput - trainOutput);
  deltaHidden = (wOutput(1:end-1, :) * deltaOutput) .* (1 - yHidden(1:end-1, :) .^ 2);
  
  deltawHidden = -rho * extendedInput * deltaHidden';
  deltawOutput = -rho * yHidden * deltaOutput';
  
  wOutput = wOutput + deltawOutput;
  wHidden = wHidden + deltawHidden;
end

% Testing with the test data
N = size(testdata, 2);
extendedInput = [testdata; ones(1, N)];

vHidden = wHidden' * extendedInput; % hidden layer net activation
yHidden = tanh(vHidden); % hidden layer activation function

yHidden = [yHidden; ones(1,N)]; % hidden layer extended output

vOutput = wOutput' * yHidden; % output layer net activation
yOutput = vOutput; % output layer output without activation f

[tmp, testclass] = max(yOutput, [], 1);

