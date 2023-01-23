function w_a = adsorption(kbT,delta,Xi)

    w_a = exp(abs(delta)/(Xi*kbT));
end