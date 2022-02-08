outputFolder='/panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/Tedana_html_outputs';
cd('/panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/data')


inputFiles = dir('*/*/tedana_report.html');
fileNames = { inputFiles.name };
pathNames= { inputFiles.folder };
for k = 1 : length(inputFiles )-16 % excluding oddball runs for now
  thisFileName = fileNames{k};
  thisPathName=pathNames{k};
  thisPathNameFigures=[thisPathName, '/figures'];
  if contains(thisPathName, 'NORDIC') 
      ses='NORDIC';
  else
      ses='noNORDIC';
  end
  str_ind=strfind(thisPathName, '20211105');
  number=thisPathName(str_ind+8:str_ind+15);
  str_ind2=strfind(thisPathName, 'tedana/');
  run=thisPathName(str_ind2+7:str_ind2+9);
  % Prepare the input filename.
  inputFullFileName = fullfile(thisPathName, thisFileName);
  % Prepare the output folder name
  outputFolderName = [outputFolder, '/sub-4049_', ses , number, run];
  mkdir([outputFolderName]);
  outputFullFileName=[outputFolderName, '/', thisFileName];
  % Do the copying and renaming all at once.
  copyfile(inputFullFileName, outputFolderName);
  copyfile(thisPathNameFigures, [outputFolderName, '/figures']);
end