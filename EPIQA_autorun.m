% EPIQA_autorun
% Run epiQA on 10min dailyQA EPI data, assuming standard QA protocol.
% Requires:
%   EPIautoQAlist.txt:  list of exam numbers and tarballs to be processed
%         this can be generated with script EPIQA.procyesterday

QAdir = '/cubric/users/sapje1/QA';
EPIQAdir = '/cubric/users/sapje1/QA/EPI';

year=datestr(now,'yyyy');
tarballdir=['/cubric/mri/direct_transfer/' year '/'];

cmd = [ 'cd ' EPIQAdir];
system(cmd);
% system('cd /cubric/users/sapje1/QA/EPI');

% ScanLog = '/home/sapje1/QA/scanlistOctNov.txt';

%fid1 = fopen('/cubric/users/sapje1/QA/EPI/QAtarballlist.txt');
fnameqalist = [ EPIQAdir '/EPIQA_autolist.txt' ];
%fid1 = fopen('/cubric/users/sapje1/QA/EPI/EPIautoQAlist.txt');
fid1 = fopen(fnameqalist);
SS=textscan(fid1, '%s %s\n');
%fclose(fid1);

examno = SS{1};
tarball = SS{2};

fclose(fid1);

for nnex = 1 : numel(examno)
    cmd = [ EPIQAdir '/temp' ];
    cd(cmd)
    
    cmd=['/cubric/software/bin/sortdicomball ' tarball{nnex} ' .'];
    system(cmd);
    cmd = 'ls -1rt | tail -n 1';
    [aa,unpackdir] = system(cmd);
    % there is a RET at the end of this string which stops cd from working
    unpackdir=unpackdir(1:(end-1));
    cd(unpackdir)
    
    % find whether there is EPI_spike data (1200 images)
    seriesdirs = dir('.');
    numseries = numel(seriesdirs);
    spikedir='';
    epidir='';
    for jjj = 3:numseries    % don't do . and ..
        nimg(jjj) = numel(dir(seriesdirs(jjj).name))-2; %don't count . and ..
        if(nimg(jjj) == 1200) %this will only analyse the last one
            spikedir = seriesdirs(jjj).name;
        elseif(nimg(jjj) == 9000) % it's the 10 min EPI run
            epidir = seriesdirs(jjj).name;
        end
        
    end
    
    % EPIQA data - has to be series 4
    %if(exist('Series_00004')==7) % there is a series 4 folder
    if(isempty(epidir) == 0)
        %cd('Series_00004');
        cd(epidir);
        cmd=['/cubric/software/bin/geprepfunct 30 300 /home/sapje1/QA/EPI/EPIQAdata/' examno{nnex} '_EPIQA' ];
        system(cmd)
        %fname=[ '/home/sapje1/QA/EPI/EPIQAdata/' examno{nnex} '_EPIQA.nii.gz' ]
        fname=[ EPIQAdir '/EPIQAdata/' examno{nnex} '_EPIQA.nii.gz' ];
        epiQA   
       
        % move the PDF to the Summary dir
        cmd = [ 'mv ' EPIQAdir '/EPIQAdata/' examno{nnex} '_EPIQA.pdf ' EPIQAdir '/Summary/'  ];
        system(cmd)
        
        Summary_file = [ EPIQAdir '/EPIQA_summary.txt' ];
        %fid_sfnr = fopen('/cubric/users/sapje1/QA/EPI/SFNR_summary.txt', 'a+')
        fid_sfnr = fopen(Summary_file, 'a+');
        fprintf(fid_sfnr, '%s %7.1f %7.1f %7.1f %7.3f\n', examno{nnex}, SFNR_Summary, ...
            SNR_Summary, Signal_Summary, SlicePSC_Max);
        
        tmpfile = [ EPIQAdir '/tmp.txt' ];
        
        cmd = ['echo "Summary of results from last 10 EPIQA scans" > ' tmpfile];
        system(cmd);
        cmd = ['echo "Exam SFNR       SNR        Signal      MaxSigChange%" >> ' tmpfile];
        system(cmd);
        cmd = ['cat ' Summary_file ' | tail -n 10 >> ' tmpfile];
        system(cmd);
        
        Drift_file = [ EPIQAdir '/EPIdrift_summary.txt' ];
        fid_sfnr = fopen(Drift_file, 'a+');        
        fprintf(fid_sfnr, '%s %f\n', examno{nnex}, LinearDrift);
       
        pdfname = [ EPIQAdir '/Summary/' examno{nnex} '_EPIQA.pdf ']
        % Email PDF and text of last 10 EPIQA runs
        cmd = ['cat ' tmpfile ' | mailx -s "MRautoQA EPIQA ' ...
            examno{nnex} ...
            '" -a ' pdfname ' cje.cubric@gmail.com'];
        system(cmd);
        
      
        
    end
    % EPI_spike data - needs to have 1200 images.    
    if(isempty(spikedir) == 0) % not empty... so there IS an EPI_spike directory
        cmd = [ EPIQAdir '/temp' ];
        cd(cmd);
        cd(unpackdir);
        cd(spikedir);
        cmd=['/cubric/software/bin/geprepfunct 1200 1 /home/sapje1/QA/EPI/temp/'  examno{nnex} '_spike' ];
        system(cmd);
        fnspike=[ '/home/sapje1/QA/EPI/temp/' examno{nnex} '_spike.nii.gz' ]; 
        epispike
        pdfname=[ fnspike(1:(end-7)) '.pdf' ];
 

        % move the PDF to the Summary dir
        cmd = [ 'mv /home/sapje1/QA/EPI/temp/'  examno{nnex} '_spike.pdf ' EPIQAdir '/Summary/'  ];
        system(cmd);
        Summary_file = [ EPIQAdir '/EPIspike_summary.txt' ];
        fid_sfnr = fopen(Summary_file, 'a+');        
        fprintf(fid_sfnr, '%s %f\n', examno{nnex}, imageswithspikes);
        
        cmd = ['echo "Summary of results from last 10 EPI spike tests" > ' tmpfile];
        system(cmd);
        cmd = ['echo "Exam Nspike" >> ' tmpfile];
        system(cmd);
        cmd = ['cat ' Summary_file ' | tail -n 10 >> ' tmpfile];
        system(cmd);
               
        pdfname = [ EPIQAdir '/Summary/' examno{nnex} '_spike.pdf ']
        
        % email PDF and text of last 10 spike runs
        cmd = ['cat ' tmpfile ' | mailx -s "MRautoQA EPIspike ' ...
                    examno{nnex} ...
                    '" -a ' pdfname ' cje.cubric@gmail.com']        
         system(cmd);
        
    end
    
end

% tidy up
cmd = ['rm -rf ' EPIQAdir '/temp/*' ]
system(cmd);
