function phScope_process(data)
	global state

    nChans=length(state.phys.scope.channelsUsed);
    
  	for counter=1:nChans    
        
        channel=state.phys.scope.channelsUsed(counter);
        channelString=num2str(channel);
        
        chanData=data(:,counter)*state.phys.scope.gainToUse(counter);

        % calculate the baseline based on all data before the pulse
        baseline = mean(chanData(1:state.phys.scope.pointsUntilPulse(counter)-1));
        if state.phys.scope.baselineSubtract
            chanData=chanData-baseline;
            baseline = 0;
        end
	
        % calculate the steady state from the last points in the pulse
        endline = mean(chanData(round(2.8*state.phys.scope.pointsUntilPulse(counter)) ...
            : (3*state.phys.scope.pointsUntilPulse(counter)-1)));
	
      	setWave(['scopeInput' channelString], 'data', ...
            chanData(1:4*state.phys.scope.pointsUntilPulse(counter))');
        
        if state.phys.scope.doFFT
            phScope_doFFT(channel)
        end
        drawnow

        if (nChans==1) || (channel==1)
            if state.phys.scope.CCUsed(counter)
                if state.phys.scope.ampsUsed(counter)~=0
                    state.phys.scope.RIn=1000*(endline-baseline)/state.phys.scope.ampsUsed(counter);
                else
                    state.phys.scope.RIn=0;
                end
            else
                state.phys.scope.RIn=1000*state.phys.scope.ampsUsed(counter)/(endline-baseline);
            end
        end

        state.phys.scope.RIn=round(100*state.phys.scope.RIn)/100;
    
        if state.phys.scope.calcSeries && ...
                ~state.phys.scope.CCUsed(counter) && ...
                state.phys.scope.ampsUsed(counter)~=0
            if state.phys.scope.ampsUsed(counter)>0
                [peak, peakloc]=max(chanData);
            else
                [peak, peakloc]=min(chanData);
            end
            
            calcError=0;
            
            switch state.phys.scope.calcSeriesMethod
                case 1
                    % Existing Code
                    delta=round(0.1*state.phys.scope.pointsUntilPulse(counter));
                    peak1=peak-endline;
                    peak2=chanData(delta+peakloc)-endline;
                    peak3=chanData(2*delta+peakloc)-endline;
                    if (peak1-peak2)*(peak2-peak3)>0
                        peakloc=peakloc-state.phys.scope.pointsUntilPulse(counter)+1;
                        tau=delta*(1/log(peak1/peak2)+1/log(peak2/peak3)+2/log(peak1/peak3))/3;
                        amp=(peak1*exp(peakloc/tau)+peak2*exp((peakloc+delta)/tau)+peak3*exp((peakloc+2*delta)/tau))/3;
                    else
                        disp('phScope_process: current is not monotonic.  Series calculation skipped preformed')
                        calcError=1;
                        amp=nan;
                        tau=nan;
                        peakloc=nan;
                    end

                case 2
                    %Matlab polyfit to get tau & amp
                    Data = chanData(peakloc:3*state.phys.scope.pointsUntilPulse(counter)-1)-endline;
                    peak1=(peak-endline)*0.9; 
                    peak3=(peak-endline)*0.3; % Get data index for 10%, 50% 90% of the peak
                    ix1=find(Data<peak1,1,'last'); 
                    ix3=find(Data<peak3,1,'last');
    %                 warning('off')
                    fit=polyfit(ix1:ix3,log(-Data(ix1:ix3)'),1); % fit
                    tau=-1/fit(1); 
                    amp=-exp(fit(2));

            end

            if calcError
                state.phys.scope.Rs=nan;
                state.phys.scope.RIn=nan;
                state.phys.scope.Cm=nan;
            else                
                state.phys.scope.Rs=round(10*1000*state.phys.scope.ampsUsed(counter)/amp)/10;
                state.phys.scope.RIn=round(10*(state.phys.scope.RIn-state.phys.scope.Rs))/10;
                state.phys.scope.Cm=round(10*1000*1000*tau/state.phys.scope.rate/state.phys.scope.Rs)/10;
            end

            updateGuiByGlobal('state.phys.scope.RIn');
            updateGuiByGlobal('state.phys.scope.Rs');	
            updateGuiByGlobal('state.phys.scope.Cm');	

            state.phys.cellParams.(['rm' channelString])=state.phys.scope.RIn;
            state.phys.cellParams.(['rs' channelString])=state.phys.scope.Rs;
            state.phys.cellParams.(['cm' channelString])=state.phys.scope.Cm;

            updateGuiByGlobal(['state.phys.cellParams.rm' channelString]);
            updateGuiByGlobal(['state.phys.cellParams.rs' channelString]);	
            updateGuiByGlobal(['state.phys.cellParams.cm' channelString]);	

            if calcError
                 setWave(['scopeInputFit' channelString], ...
                    'data', nan(1,10));
            else
                setWave(['scopeInputFit' channelString], ...
                    'data', real(amp*exp(-[0:2*state.phys.scope.pointsUntilPulse(counter)-1]/tau)+endline));
            end

            state.phys.scope.RsAvg= round(10*...
                (state.phys.scope.RsAvg*state.phys.scope.counter+state.phys.scope.Rs)/(state.phys.scope.counter+1))/10;
            state.phys.scope.CmAvg= round(10*...
                (state.phys.scope.CmAvg*state.phys.scope.counter+state.phys.scope.Cm)/(state.phys.scope.counter+1))/10;
            updateGuiByGlobal('state.phys.scope.RsAvg');
            updateGuiByGlobal('state.phys.scope.CmAvg');
        else
            updateGuiByGlobal(['state.phys.cellParams.rm' channelString]);
            state.phys.cellParams.(['rm' channelString])=state.phys.scope.RIn;
            updateGuiByGlobal('state.phys.scope.RIn');
        end
	
        state.phys.scope.RInAvg=round(10*...
            (state.phys.scope.RInAvg*state.phys.scope.counter+state.phys.scope.RIn)/(state.phys.scope.counter+1))/10;
        state.phys.scope.counter=state.phys.scope.counter+1;
        updateGuiByGlobal('state.phys.scope.RInAvg');
    end
