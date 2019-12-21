function phScope_doFFT(channel)
%phSCopt_doFFT : Calculate the FFT of the last scope acquisition
%   and store it in a wave

    channelString=num2str(channel);
    Y=getWave(['scopeInput' channelString], 'data');
    dt=getWave(['scopeInput' channelString], 'xscale');
    L=length(Y);
    Y=fft(Y);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);P1(2:end-1) = 2*P1(2:end-1);
    f = 50000*(0:(L/2))/L;
    fstep=f/L;

    setWave(['scopeFFT' channelString], 'data', P1, 'xscale', [0 (1000/dt(2))/L]);

end

