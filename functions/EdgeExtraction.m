function [Edges, Ihor, Iver] = EdgeExtraction(Iin,B1,B2)

Ihor = myconvolution(Iin, B2);
Iver = myconvolution(Iin, B1);
Edges = sqrt((Iver).^2 + (Ihor).^2);

end