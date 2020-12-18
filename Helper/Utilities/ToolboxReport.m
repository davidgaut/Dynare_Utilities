
function ToolboxReport()
% ToolboxReport
%-----------------------------------------------------------------
% Bank of England - 01/12/2020
% Gauthier, David <David.Gauthier@bankofengland.co.uk>
% 
% Scan files in directory and survey toolboxes used. 
% The process restarts from the last saving point if interupted.
% All the files to scan need to be in th directory or in one of its
% subfolder.
%-----------------------------------------------------------------

% Report path
username  = strcat(getenv('USERNAME'),'_');
path_save = 'Z:\Survey\MatLab\Toolboxes\';

if exist(strcat(path_save,username,'ToolboxReport_Final.mat'),'file')
    warning(strcat('Report already completed (',path_save,username,'ToolboxReport_Final.mat)'))
%     input('Do you want to restart scan (from scratch)? (y/n)',s)
%     if strcmp(s,'y') 
%         first_file  = 1; ToolboxList = [];
%         fprintf('\nStarting new scan\n------------------\n')
%     else 
%         return
%     end
    former_run  = load(strcat(path_save,username,'ToolboxReport_Final.mat'));
    ToolboxList = former_run.TLU;
    NameList    = former_run.NameList;
    first_file  = 1;
    fprintf('\nRestarting former scan (from file nbr %d)\n-----------------------------------------\n',first_file)

elseif exist(strcat(path_save,username,'ToolboxReport_Interm.mat'),'file')
    former_run  = load(strcat(path_save,username,'ToolboxReport_Interm.mat'));
    ToolboxList = former_run.TL;
	NameList    = former_run.NameList;
    first_file  = former_run.file_nbr;
    fprintf('\nRestarting former scan (from file nbr %d)\n-------------------------------------------\n',first_file)
else
    first_file  = 1; ToolboxList = []; NameList = []; TL = []; file_nbr = 1; LineCount = 0;
    fprintf('\nStarting new scan\n------------------\n')
    % Check permission
    try
    save(strcat(path_save,username,'ToolboxReport_Interm'),'TL','file_nbr','LineCount','NameList')
    catch
        error('Access to save directory not granted, try to restart computer.')
    end
end    
    
% List files to scan (in all subdir)
all_path  = [{cd};split(genpath(cd),';')];
list_file = []; ll = 2; fprintf('\n\n\n')
for ij = 1:length(all_path)
    pgs = join(['Listing folders: ',num2str(ij),' / ',num2str(length(all_path))]);
    fprintf([repmat('\b',1,ll),pgs]); ll = length(pgs);
    dir_file  = dir(all_path{ij});
    list_file = [list_file; strcat(all_path{ij},'\',{dir_file.name})'];
end
% finished  = 0;
% while ~finished
%     [list_file, finished] = find_files(list_file);
% end
list_file = unique(list_file(endsWith(list_file,'.m')));
fprintf('\n\n-> Search directory is %s.\n-> Number of file to scan is %d.\n\n',cd,length(list_file))

if isempty(list_file); error('No Matlab files here.');end

% Run scan filestep
MeList = []; ll = 0; LineCount = 0; ct = 0;
for file_nbr = first_file:length(list_file)
    pgs1 = join(['Progress: ', num2str(file_nbr),'/',num2str(length(list_file)),' - (',list_file{file_nbr},')']);
    fprintf([repmat('\b',1,ll),strcat(replace(pgs1,'\','\\'),'\n')])    
    ll = length(pgs1) + 1;
    try
        ct          = ct + 1;
        [~, pList]  = matlab.codetools.requiredFilesAndProducts(list_file{file_nbr});  
        pName       = {pList.Name};
        ToolboxList = [ToolboxList,pName];
        NameFile    = regexp(list_file{file_nbr},'(\w*)\.m','tokens');
        NameFile    = [NameFile{:};sort(pName)'];
        NameList    = [NameList,{NameFile}];
        LineCount   = LineCount + line_count(list_file{first_file});
    catch ME
        MeList = [MeList,ME.message];
    end
    if ~rem(file_nbr,20)
        TL = unique(ToolboxList)';
        save(strcat(path_save,username,'ToolboxReport_Interm'),'TL','file_nbr','NameList')
    end
end

% Generate Report
TLU = unique(ToolboxList)';
save(strcat(path_save,username,'ToolboxReport_Final'),'TLU','LineCount','NameList')
delete(strcat(path_save,username,'ToolboxReport_Interm.mat'))
fprintf('\nReport completed.\n')
end

% function [files, finished] = find_files(ff_list)
%     finished  = 0;
%     folders   = ff_list(cellfun(@isempty,regexp(ff_list,'.*\..*','match')));
%     fold_file = cellfun(@(folder) strcat(folder,'\',{dir(char(folder)).name})',folders,'UniformOutput',false);
%     for i = 1:length(fold_file); ff_list = [ff_list;fold_file{i}]; end
%     files     = unique(ff_list);
%     if isequal(unique(ff_list),files); finished  = 1; end
% end

function lnbr = line_count(file_name)
    fid = fopen(file_name);
    g   = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    lnbr = length(g{:});
end