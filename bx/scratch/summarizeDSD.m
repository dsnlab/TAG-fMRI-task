for x = 1:17;
    for y = 1:2;
        Sp(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Sp));
        Sf(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Sf));
        Fp(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Fp));
        Fs(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Fs));
        Pf(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Pf));
        Ps(x,y)=nanmean(drs(x).dsd(y).choice.gross(drs(x).dsd(y).choice.trials.Ps));
        grossPay = [nanmean(Sp(:)) nanmean(Sf(:)) 0;
            nanmean(Fp(:))  0 nanmean(Fs(:));
            0 nanmean(Pf(:)) nanmean(Ps(:))];
    end
end
%%

for x = 1:17;
    for y = 1:2;
        Sp(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Sp));
        Sf(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Sf));
        Fp(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Fp));
        Fs(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Fs));
        Pf(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Pf));
        Ps(x,y)=nanmean(drs(x).dsd(y).choice.net(drs(x).dsd(y).choice.trials.Ps));
        netPay = [nanmean(Sp(:)) nanmean(Sf(:)) 0;
            nanmean(Fp(:))  0 nanmean(Fs(:));
            0 nanmean(Pf(:)) nanmean(Ps(:))];
            
        
    end
end

%%

for x = 1:17;
    for y = 1:2;
        Sp(x,y)=length(drs(x).dsd(y).choice.trials.Sp);
        Sf(x,y)=length(drs(x).dsd(y).choice.trials.Sf);
        Fp(x,y)=length(drs(x).dsd(y).choice.trials.Fp);
        Fs(x,y)=length(drs(x).dsd(y).choice.trials.Fs);
        Pf(x,y)=length(drs(x).dsd(y).choice.trials.Pf);
        Ps(x,y)=length(drs(x).dsd(y).choice.trials.Ps);
        
            
        
    end
end
      
