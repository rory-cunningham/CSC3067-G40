function Iout = myconvolution(Iin,B)
    %Task1 Step 6
    Iin=double(Iin);
    B=double(B);

    Iout = zeros((size(Iin,1)-size(B,1)+1) ,(size(Iin,2)-size(B,2)+1));

    %For loops manage rows/columns for new image C
    for K = 1:size(Iout,1)
        for L = 1:size(Iout,2)

            %For loops manage rows/columns old image Iin
            value = 0.0;
            for i = K:(K+size(B,1)-1)
                for j = L:(L+size(B,2)-1)
                    value = value + (Iin(i,j) * B((i-K+1), (j-L+1)));
                end
            end
            
            %Set Value
            Iout(K,L) = value;
        end
    end
end