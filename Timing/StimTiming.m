% StimTiming.m
% function [tt_min, scanner_delta_t, scannerlag_ms_min, lag_resid, actTR] ...
%    = eprime_stimtiming(fname)
% get timing info from eprime file
%   tt = time axis (minutes)
%   scanner_delta_t   = vector of temporal lag (ms) of scanner relative to
%                       stim PC
%   scannerlag_ms_min = linear component of lag in ms per minute (from polyfit)
%   lag_resid         = stdev of residuals of linear fit to drift in ms (i.e.
%                       reflects how linear the drift is) 

TR=2;           % in s

% get filename from transfer logs...
fname = importdata('/home/sapje1/QA/Timing/TimingFiles/fname.txt')

nfiles = numel(fname)


for jj = 1:nfiles
    fullfname = ['/home/sapje1/QA/Timing/TimingFiles/' fname{jj}];
    if( ~ exist(fullfname))
        disp('File doesnt exist');
    else
        
        [aa, examno, bb] = strread(fname{jj}, '%s %s %s', 'delimiter', '-');
        examno
        fname{jj}
       
        cmd = ['cat ' fullfname ' | grep -i readport.onsettime | awk ' char(39) ...
            '{print $2}' char(39) ' > onsettime.txt'];
        system(cmd);
        
        load onsettime.txt;
        
        %onset times in s
        onsettime = onsettime / 1000;
        
        % get rid of first entry - before first trig
        onsettime(1) = [];
        
        % time of trigger, measured by stim PC
        MRtriggertime = onsettime - onsettime(1);
        %actTR = 1000*MRtriggertime(end) / (length(MRtriggertime)-1)
        
        nvols = length(onsettime);
        
        tt = TR * [ 0 : (nvols-1) ]'; % in s
        tt_min = tt / 60;
        
        scanner_delta_t = (MRtriggertime - tt) * 1000; % in ms
        
        fitpar = polyfit(tt_min, scanner_delta_t,1);
        scannerlag_ms_min = fitpar(1)
        fitline = tt_min*scannerlag_ms_min + fitpar(2);
        
        actTR = 1000* TR + scannerlag_ms_min / (60/TR);
        
        resid = fitline - scanner_delta_t;
        %figure(3); plot(resid);
        lag_resid = std(resid);
        
        hh=figure;
        set(hh,'Visible','off');
        
        plot(tt_min, scanner_delta_t, tt_min, fitline);
        
        xlabel('time (min)')
        set(gca, 'FontSize', 14)
        ylabel('Scanner Lag (ms)')
        set(gca, 'FontSize', 14)
        tmp = [ 'Scanner Lag =' num2str(scannerlag_ms_min,'%.1f') 'ms/min' ];
        text(4,0,tmp)
        clear pdfname;
        pdfname=[ '/home/sapje1/QA/Timing/Summary/' examno{1} '_timing.pdf' ];
        
        % Use export_fig from matlabcentral
        export_fig(pdfname)
        outd = ['Timing analysis saved to ' pdfname ];
        disp(outd)
                
        Summary_file = [ '/home/sapje1/QA/Timing/Timing_summary.txt' ];
        %fid_sfnr = fopen('/cubric/users/sapje1/QA/EPI/SFNR_summary.txt', 'a+')
        fid_sfnr = fopen(Summary_file, 'a+');
        fprintf(fid_sfnr, '%s %.2f\n', examno{1}, scannerlag_ms_min);
        tmpfile = [ '/home/sapje1/QA/Timing/tmp.txt' ];
        cmd = ['cat ' Summary_file ' | tail -n 10 > ' tmpfile];
        system(cmd);
         
        % email PDF and text of last 10 spike runs
        cmd = ['cat ' tmpfile ' | mailx -s "MRautoQA EPItiming ' ...
                    examno{1} ...
                    '" -a ' pdfname ' cje.cubric@gmail.com']        
         system(cmd);

        
    end
end



