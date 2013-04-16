% EPIQA_autosummary.m
% Generate summary report from 

EPIQADIR = '/cubric/users/sapje1/QA/EPI';

cd(EPIQADIR);

% load, and deal with multiple entries
tmp=load('EPIQA_summary.txt');
tmp2=sortrows(tmp,1);

examno=tmp2(:,1);
SFNR=tmp2(:,2);
SNR=tmp2(:,3);
signal=tmp2(:,4);
slicePSC=tmp2(:,5);


hh=figure;
set(hh,'Visible','off');
set(hh, 'Position', [ 134    87  887  560  ]);

subplot(3,2,1)
plot(examno, SFNR, '.-') %, 'MarkerSize', 3)
title('SFNR')

subplot(3,2,2)
plot(examno, SNR, '.-');
title('SNR')

subplot(3,2,3)
stem(examno, slicePSC, '.-')
% ylim([0 0.75]);title('Max Slice \Deltasignal %');
% [haxes,hline1,hline2] = plotyy(examno, slicePSC, examno,slicePSC);
title('Max Slice \Deltasignal %'); 
% %set(hline1,'color','w');
% set(hline1,'Marker','o');
% %set(hline2,'LineStyle','-');
% set(hline2,'Marker','o');
% axes(haxes(2));
ylim([0 0.8]);

subplot(3,2,6)
plot(examno, signal, '.-');
title('Mean Signal') 
plotxlim = xlim;

tmp = load('EPIspike_summary.txt');
tmp3 = sortrows(tmp,1);
examnoSPK = tmp3(:,1);
nSpkImg = tmp3(:,2);

subplot(3,2,4)
stem(examnoSPK, nSpkImg, '.-')
xlim(plotxlim);
title('N images with spikes (of 1200)')

tmp = load('EPIdrift_summary.txt');
tmp3 = sortrows(tmp,1);
examnoDrift = tmp3(:,1);
Drift = tmp3(:,2);

subplot(3,2,5);
plot(examnoDrift, Drift, '.-');
title('Signal Drift (%)')


pdfname=[ 'EPIQA_summary.pdf' ];

export_fig(pdfname)
outd = ['EPI summary analysis saved to ' pdfname ];
disp(outd)

cmd = ['echo "Summary of results from last 10 EPIQA scans" > tmp.txt'];
system(cmd);
cmd = ['echo "Exam SFNR       SNR        Signal      MaxSigChange%" >> tmp.txt'];
system(cmd);
cmd = ['cat EPIQA_summary.txt | tail -n 10 >>tmp.txt'];
system(cmd);

cmd = ['echo >> tmp.txt'];
system(cmd);
cmd = ['echo "Exam Nspike" >> tmp.txt'];
system(cmd);
cmd = ['cat EPIspike_summary.txt | tail -n 10 >> tmp.txt'];
system(cmd);

cmd = ['cat tmp.txt | mailx -s "MRautoQA EPI Summary (after exam ' ...
    num2str(examno(end)) ...
    ')" -a ' pdfname ' cje.cubric@gmail.com'];
system(cmd)

%cmd = ['echo "EPI QA Summary" | mailx -s "MRautoQA EPI Summary (after exam ' ...
%    num2str(examno(end)) ...
%    ')" -a ' pdfname ' cje.cubric@gmail.com'];
%         No exam no in subject
%         cmd = ['echo "EPI Spike Test ' examno{nnex} ...
%             '" | mailx -s "MRautoQA EPIspike' ...
%             '" -a ' pdfname ' cje.cubric@gmail.com'];
%system(cmd);




