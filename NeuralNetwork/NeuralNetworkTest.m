function [ confidence ] = NeuralNetworkTest( Model, Tests )

Tests = Tests.';

confidence = Model(Tests);
confidence = confidence(2,:).';

end