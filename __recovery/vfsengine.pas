unit vfsengine;

(*

Virtual File System engine v1.0
(c) 2007-2020 T. Pitkänen
-------------------------------

*)

interface

uses
  Classes,
  md5,
   SysUtils,
Windows,  JclStrings,
  zlibex,
  JclFileUtils;

type
  vfs_file_entry = record
    filenamelength:    integer;
    filename:          ansistring;
    file_offset:       integer;
    file_compressed:   boolean;
    size_compressed:   integer;
    size_uncompressed: integer;
    file_date:         tdatetime;
    file_added:        tdatetime;
    file_opened:       boolean;
    md5checksum:       tmd5digest;
  end;

const
  signature: array[0..3] of ansichar = 'VFSP';
  savegame: array [0..3] of ansichar = 'SAV0';

type
  vfs_header_rec = record
    packfilechecksum: integer;
    packfilename:    ansistring;
    packdescription: ansistring;
    files:           array of ^vfs_file_entry;
    datablocksize:   integer;
    numfiles:        integer;
    offset_to_files: integer;
    globaloffset:    integer;
    packfilemd5:     tmd5digest;
    timestamp:       tdatetime;
    creator:         ansistring;
  end;

const
  buffersize = 65536 * 2;

var
  buf:          array[0..buffersize - 1] of ansichar;
  buffer_sizes: array[0..1024] of word;
  buffer:       array[0..buffersize - 1] of byte;
  src_stream:   tstream;
  gievmemd5:    tmd5digest;
  dest_stream:  tstream;
  md5textfile:  TStrings;
  vfs_input:    vfs_header_rec;
  bufcount, lastbuf, numread, numwritten, byteswritten, bytesread: integer;
  console_output: TStrings;
  logfile:      TStrings;
  compressor:   tzcompressionstream;
  windowstemp:  ansistring;
  outputfile:   file;
  files_temp:   file;

procedure createnewpackfile(var outputfile: file; var packfile: vfs_header_rec;
  creator: ansistring = 'djunique'; filename: ansistring = '');
function vfs_get_file_index(packfile: vfs_header_rec; const filename: ansistring): integer;
procedure add_file_to_vfs(var packfile: vfs_header_rec; filename: ansistring);
function vfs_get_file_index_with_mask(packfile: vfs_header_rec;
  const filename: ansistring): integer;
function compress_(filename: ansistring; compressionratio: tzcompressionlevel): longint;
procedure consoleoutputnoln(thestr: ansistring);
procedure silentoutput(thestr: ansistring);
procedure writeheader(var outputfile: file; packfile: vfs_header_rec);
procedure closevfshandle(var outputfile: file);
procedure addfileswithwildcard(var packfile: vfs_header_rec; pattern: ansistring;
  var numfound: integer; recursive: boolean = True);
procedure openvfspackfile(var vfsfile: file; var packfile: vfs_header_rec;
  filename: ansistring);
procedure consoleoutput(thestr: ansistring);
procedure open_from_vfs(var filehandle: file; packfile: vfs_header_rec;
  filename: ansistring; fullpath: boolean = False; destpath: ansistring = '');
procedure vfs_cleanup(packfile: vfs_header_rec; pathoverride: ansistring = '');
procedure extract_data_block(var filehandle: file; packfile: vfs_header_rec);
procedure cleanupdatablock;
procedure vfs_save_log;
procedure open_from_vfs_fullpath(var filehandle: file; packfile: vfs_header_rec;
  filename: ansistring; fullpath: boolean = False; destpath: ansistring = '');
function vfs_file_exists(packfile: vfs_header_rec; const filename: ansistring): boolean;

implementation

uses
 Math,  Masks;

procedure writestring(var f: file; Data: ansistring);
var
  t, len: integer;
  s: ansichar;
begin
  len := length(Data);
  blockwrite(f, len, 4);
  for t := 1 to len do
  begin
    s := Data[t];
    blockwrite(f, s, sizeof(s));
  end;
end;

procedure writestringnolength(var f: file; Data: ansistring);
var
  t, len: integer;
  s: ansichar;
begin
  len := length(Data);
  for t := 1 to len do
  begin
    s := Data[t];
    blockwrite(f, s, sizeof(s));
  end;
end;

procedure decompress(infile: ansistring);
var
  Count: integer;
  _infile, _outfile: tstream;
  zstream: tzdecompressionstream;
begin
  try
    _infile := tfilestream.Create(infile + '.zlib', fmopenread);
    try
      _outfile := tfilestream.Create(infile, fmcreate);
      try
        zstream := tzdecompressionstream.Create(_infile);
        try
          while True do
          begin
            Count := zstream.Read(buffer, buffersize);
            if Count <> 0 then
              _outfile.writebuffer(buffer, Count)
            else
              break;
          end;
        finally
          zstream.Free;
        end;
      finally
        _outfile.Free;
      end;
    finally
      _infile.Free;
    end;
    deletefile(pwidechar(infile + '.zlib'));
  except
    on e: Exception do
    begin
      consoleoutput('Error: ' + e.message);
    end;
  end;
end;

procedure decompress_as(infile, newfile: ansistring);
var
  Count: integer;
  _infile, _outfile: tstream;
  zstream: tzdecompressionstream;
begin
  ;
  _infile := tfilestream.Create(infile, fmopenread);
  try
    _outfile := tfilestream.Create(newfile, fmcreate);
    try
      zstream := tzdecompressionstream.Create(_infile);
      try
        while True do
        begin
          Count := zstream.Read(buffer, buffersize);
          if Count <> 0 then
            _outfile.writebuffer(buffer, Count)
          else
            break;
        end;
      finally
        zstream.Free;
      end;
    finally
      _outfile.Free;
    end;
  finally
    _infile.Free;
  end;
  deletefile(pwidechar(infile));
end;

procedure vfs_save_log;
begin
  consoleoutput('-- end of logfile --');
  logfile.SaveToFile('vfsp_engine.log');
  logfile.Clear;
end;


function file_is_compressible(filename: ansistring): boolean;
begin
  Result := (lowercase(extractfileext(filename)) <> '.mp3') and
    (lowercase(extractfileext(filename)) <> '.wav') and
    (lowercase(extractfileext(filename)) <> '.flac') and
    (lowercase(extractfileext(filename)) <> '.ogg') and
    (lowercase(extractfileext(filename)) <> '.gif') and
    (lowercase(extractfileext(filename)) <> '.png');
end;

procedure cleanupdatablock;
var s: boolean;
temp: string;
begin
  if fileexists(windowstemp + '\vfs_temp.tmp') then
  begin
    consoleoutput('deleting temporary data block.');
   temp:=windowstemp + '\vfs_temp.tmp';
   s:= deletefile(pwidechar(temp));
  if s=false then consoleoutput('Delete failed!');

  end;
end;

function returnfilesize(filename: ansistring): integer;
var
  temp: file;
begin
  assignfile(temp, filename);
  reset(temp, 1);
  Result := filesize(temp);
  closefile(temp);
end;

function vfs_file_exists(packfile: vfs_header_rec; const filename: ansistring): boolean;
var
  t: integer;
begin
  Result := False;
  for t := 0 to packfile.numfiles - 1 do
  begin
    if lowercase(filename) = lowercase(packfile.files[t].filename) then
    begin
      Result := True;
      exit;
    end;
  end;
end;


function vfs_get_file_index_with_mask(packfile: vfs_header_rec;
  const filename: ansistring): integer;
var
  t: integer;
begin
  Result := -1;
  for t := 0 to packfile.numfiles - 1 do
  begin
    if MatchesMask(lowercase(extractfilename(packfile.files[t].filename)),
      lowercase(filename)) then
    begin
      Result := t;
      exit;
    end;
  end;
end;


function vfs_get_file_index(packfile: vfs_header_rec; const filename: ansistring): integer;
var
  t: integer;
begin
  Result := -1;
  for t := 0 to packfile.numfiles - 1 do
  begin
    if lowercase(filename) = lowercase(packfile.files[t].filename) then
    begin
      Result := t;
      exit;
    end;
  end;
end;

procedure vfs_cleanup(packfile: vfs_header_rec; pathoverride: ansistring = '');
var
  t: integer;
begin
  //ConsoleOutput('Cleaning up temporary files...');
  for t :=
    0 to packfile.numfiles - 1 do
  begin
    if packfile.files[t].file_opened = True then
    begin
      if pathoverride <> '' then
      begin
      //  debug('Cleaning up ' + packfile.files[t].filename);
        deletefile(pwidechar(pathoverride + '\' + extractfilename(packfile.files[t].filename)));
      end else
      begin
      // debug('Cleaning up ' + packfile.files[t].filename+' from temp');
        deletefile(pwidechar(getenvironmentvariable('TEMP') + '\' +
          extractfilename(packfile.files[t].filename)));
      end;

    end;
  end;
end;

procedure extract_data_block(var filehandle: file; packfile: vfs_header_rec);
var
  i: integer;
  datablock: integer;
  temp_input: file;
begin
  datablock := returnfilesize(packfile.packfilename) - packfile.offset_to_files;
  seek(filehandle, packfile.offset_to_files);
  assignfile(temp_input, windowstemp + '\vfs_temp.tmp');
  rewrite(temp_input, 1);
  bufcount := datablock div buffersize;
  lastbuf  := datablock mod buffersize;
  if bufcount > 0 then
  begin
    for i := 0 to bufcount - 1 do
    begin
      blockread(filehandle, buf, sizeof(buf), numread);
      blockwrite(temp_input, buf, numread, numwritten);
    end;
  end;
  if lastbuf > 0 then
  begin
    blockread(filehandle, buf, lastbuf, numread);
    blockwrite(temp_input, buf, numread, numwritten);
  end;
  closefile(temp_input);
end;

procedure open_from_vfs_fullpath(var filehandle: file; packfile: vfs_header_rec;
  filename: ansistring; fullpath: boolean = False; destpath: ansistring = '');
var
  temphandle: file;
  checksum_infile: tmd5digest;
  checksum_outfile: tmd5digest;
  iz, index:  integer;
begin
  index := vfs_get_file_index(packfile, filename);
  if index <> -1 then
  begin
    if (packfile.files[index].file_compressed = True) then
      assignfile(temphandle, getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename) + '.zlib')
    else
      assignfile(temphandle, getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename));
    //    consoleoutput('extracting: ' + packfile.files[index].filename);
    rewrite(temphandle, 1);
    bufcount := packfile.files[index].size_compressed div buffersize;
    lastbuf  := packfile.files[index].size_compressed mod buffersize;
    seek(filehandle, packfile.offset_to_files + packfile.files[index].file_offset);
    if bufcount > 0 then
    begin
      for iz := 0 to bufcount - 1 do
      begin
        blockread(filehandle, buf, sizeof(buf), numread);
        blockwrite(temphandle, buf, numread, numwritten);
      end;
    end;
    if lastbuf > 0 then
    begin
      blockread(filehandle, buf, lastbuf, numread);
      blockwrite(temphandle, buf, numread, numwritten);
    end;
    closefile(temphandle);
    if (packfile.files[index].file_compressed = True) then
    begin
      decompress(getenvironmentvariable('TEMP') + '\' + extractfilename(filename));

    end;
    checksum_infile  := packfile.files[index].md5checksum;
    checksum_outfile := md5file(getenvironmentvariable('TEMP') + '\' +
      extractfilename(filename));
    if (md5digesttostr(checksum_infile) = md5digesttostr(checksum_outfile)) then
    begin
      //   consoleoutput('Checksum match OK');
    end
    else
    begin
      //   consoleoutput('Error: checksum mismatch!');
    end;
    packfile.files[index].file_opened := True;
    if fullpath = True then
    begin
      if extractfiledir(packfile.files[index].filename) <> '' then
      begin
        if directoryexists(extractfiledir(packfile.files[index].filename)) = False then
        begin
          if extractfiledir(packfile.files[index].filename) <> '' then
            forcedirectories(destpath + '\' + extractfiledir(
              packfile.files[index].filename));
        end;
      end;

      //    consoleoutput('attempting to copy to: ' + getcurrentdir + '\' +
      //      destpath + '\' + extractfilename(packfile.files[index].filename));

      if (copyfile(PChar(getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename)), PChar(getcurrentdir + '\' +
        destpath + '\' + extractfiledir(packfile.files[index].filename) +
        '\' + extractfilename(packfile.files[index].filename)), False) = True) then
      begin
      end else
       writeln('error copying file !!! to ' + destpath);

    end;

  end;
end;


procedure open_from_vfs(var filehandle: file; packfile: vfs_header_rec;
  filename: ansistring; fullpath: boolean = False; destpath: ansistring = '');
var
  temphandle: file;
  checksum_infile: tmd5digest;
  checksum_outfile: tmd5digest;
  iz, index:  integer;

begin
  index := vfs_get_file_index(packfile, filename);
  if index <> -1 then
  begin
    if (packfile.files[index].file_compressed = True) then
      assignfile(temphandle, getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename) + '.zlib')
    else
      assignfile(temphandle, getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename));
    rewrite(temphandle, 1);
    bufcount := packfile.files[index].size_compressed div buffersize;
    lastbuf  := packfile.files[index].size_compressed mod buffersize;
    seek(filehandle, packfile.offset_to_files + packfile.files[index].file_offset);
    if bufcount > 0 then
    begin
      for iz := 0 to bufcount - 1 do
      begin
        blockread(filehandle, buf, sizeof(buf), numread);
        blockwrite(temphandle, buf, numread, numwritten);
      end;
    end;
    if lastbuf > 0 then
    begin
      blockread(filehandle, buf, lastbuf, numread);
      blockwrite(temphandle, buf, numread, numwritten);
    end;
    closefile(temphandle);
    if (packfile.files[index].file_compressed = True) then
    begin
      decompress(getenvironmentvariable('TEMP') + '\' + extractfilename(filename));

    end;
    checksum_infile  := packfile.files[index].md5checksum;
    checksum_outfile := md5file(getenvironmentvariable('TEMP') + '\' +
      extractfilename(filename));
    if (md5digesttostr(checksum_infile) = md5digesttostr(checksum_outfile)) then
    begin
    end
    else
    begin
    writeln('Checksum mismatch on '+packfile.files[index].filename);
    end;
    packfile.files[index].file_opened := True;
    if fullpath = True then
    begin


      if (copyfile(PChar(getenvironmentvariable('TEMP') + '\' +
        extractfilename(filename)), PChar(destpath + '\' +
        extractfilename(packfile.files[index].filename)), False) = True) then
      begin
       end else
        writeln('failed to copy file to '+destpath);

    end;

  end;
end;

procedure add_file_to_vfs(var packfile: vfs_header_rec; filename: ansistring);
var
  iz: integer;
  filewascompressed: boolean;
  filein: file;
begin
  //debug('Adding: ' + filename + ' ... ');
  if fileexists(filename) = False then
  begin
   writeln('ERROR FILE NOT FOUND! ' + filename);
    exit;
  end;
  filewascompressed := False;
  if (file_is_compressible(filename)) then
  begin
    compress_(filename, zcmax);
    filewascompressed := True;
  end;
  assignfile(files_temp, windowstemp + '\vfs_temp.tmp');
  if fileexists(windowstemp + '\vfs_temp.tmp') then
  begin
    reset(files_temp, 1);
    seek(files_temp, filesize(files_temp));
  end
  else
    rewrite(files_temp, 1);
  setlength(packfile.files, packfile.numfiles + 1);
  new(packfile.files[packfile.numfiles]);
  packfile.files[packfile.numfiles].file_offset := filesize(files_temp);
  packfile.offset_to_files := packfile.offset_to_files + 4;
  if (filewascompressed) then
    assignfile(filein, extractfilename(filename) + '.zlib')
  else
    assignfile(filein, filename);
  reset(filein, 1);
  if (filewascompressed) then
  begin
    bufcount := returnfilesize(extractfilename(filename + '.zlib')) div buffersize;
    lastbuf  := returnfilesize(extractfilename(filename + '.zlib')) mod buffersize;
  end
  else
  begin
    bufcount := returnfilesize(filename) div buffersize;
    lastbuf  := returnfilesize(filename) mod buffersize;
  end;
  if bufcount > 0 then
  begin
    for iz := 0 to bufcount - 1 do
    begin
      blockread(filein, buf, sizeof(buf), numread);
      blockwrite(files_temp, buf, numread, numwritten);
    end;
  end;
  if lastbuf > 0 then
  begin
    blockread(filein, buf, lastbuf, numread);
    blockwrite(files_temp, buf, numread, numwritten);
  end;
  closefile(filein);
  packfile.files[packfile.numfiles].
    filenamelength := length(filename);
  packfile.offset_to_files := packfile.offset_to_files + 4;
  packfile.files[packfile.numfiles].filename := filename;
  packfile.offset_to_files :=
    packfile.offset_to_files + length(packfile.files[packfile.numfiles].filename);
  packfile.files[packfile.numfiles].file_compressed := filewascompressed;
  packfile.offset_to_files := packfile.offset_to_files + 1;
  GetFileLastWrite(filename, packfile.files[packfile.numfiles].file_date);
  packfile.offset_to_files := packfile.offset_to_files + sizeof(tdatetime);
  packfile.files[packfile.numfiles].file_added := now;
  packfile.offset_to_files := packfile.offset_to_files + sizeof(tdatetime);
  packfile.files[packfile.numfiles].size_uncompressed := returnfilesize(filename);
  packfile.offset_to_files := packfile.offset_to_files + 4;
  if filewascompressed = True then
    packfile.files[packfile.numfiles].size_compressed :=
      returnfilesize(extractfilename(filename) + '.zlib')
  else
    packfile.files[packfile.numfiles].size_compressed := returnfilesize(filename);
  packfile.offset_to_files := packfile.offset_to_files + 4;
  try
    gievmemd5 := md5file(filename);
  except
    on
      e: Exception do
    begin
    end;
  end;

  packfile.files[packfile.numfiles].md5checksum := gievmemd5;
  packfile.offset_to_files := packfile.offset_to_files + sizeof(tmd5digest);
  packfile.globaloffset := packfile.globaloffset + filepos(files_temp);
//  debug('Added file ' + filename + ' >> ' +
//    IntToStr(packfile.files[packfile.numfiles].size_compressed)+', offset='+inttostr(packfile.files[packfile.numfiles].file_offset));
  Inc(packfile.numfiles, 1);

  closefile(files_temp);
  if filewascompressed = True then
    deletefile(pwidechar(extractfilename(filename) + '.zlib'));
end;

procedure readstringwithlength(var f: file; var Data: ansistring; len: integer);
var
  t: integer;
var
  s: ansichar;
begin
  Data := '';
  for t := 1 to len do
  begin
    blockread(f, s, 1);
    Data := Data + s;
  end;
end;

procedure readstring(var f: file; var Data: ansistring);
var
  t: integer;
  len: integer;
var
  s: ansichar;
begin
  Data := '';
  blockread(f, len, 4);
  for t := 1 to len do
  begin
    blockread(
      f, s, 1);
    Data := Data + s;
  end;
end;

procedure openvfspackfile(var vfsfile: file; var packfile: vfs_header_rec;
  filename: ansistring);
var
  signature_: array[0..3] of char;
  t: integer;
begin
  assignfile(vfsfile, filename);
  reset(vfsfile, 1);
  if fileexists(filename) = False then
  begin
    //debug('File not found!');
    consoleoutput(filename + ': file not found.');
    exit;
  end;
  packfile.packfilename :=
    filename;
  blockread(vfsfile, signature_, 4);
  blockread(vfsfile, packfile.numfiles, 4);
  blockread(vfsfile, packfile.offset_to_files, 4);
  readstring(vfsfile, packfile.creator);
  readstring(vfsfile, packfile.packdescription);
  readstring(vfsfile, packfile.packfilename);
  blockread(vfsfile, packfile.timestamp,
    sizeof(tdatetime));
  consoleoutput('opened: ' + filename + ' - created by: ' + packfile.creator +
    ' on ' + datetimetostr(packfile.timestamp));
  consoleoutput('');
  setlength(packfile.files, packfile.numfiles);
  for t := 0 to packfile.numfiles - 1 do
  begin
    new(packfile.files[t]);
    blockread(vfsfile, packfile.files[t].md5checksum, sizeof(tmd5digest));
  end;

  for t := 0 to packfile.numfiles - 1 do
  begin
    blockread(vfsfile, packfile.files[t].filenamelength, 4);
    readstringwithlength(vfsfile, packfile.files[t].filename,
      packfile.files[t].filenamelength);
    blockread(vfsfile, packfile.files[t].file_date, sizeof(tdatetime));
    blockread(vfsfile, packfile.files[t].file_added, sizeof(tdatetime));
    blockread(vfsfile, packfile.files[t].file_offset,
      4);
    blockread(vfsfile, packfile.files[t].file_compressed, 1);
    blockread(vfsfile, packfile.files[t].size_compressed, 4);
    blockread(vfsfile, packfile.files[t].size_uncompressed, 4);
  end;

  consoleoutput('Opened VFSP file ' + filename + ' :: ' + IntToStr(packfile.numfiles) +
    ' file(s)');

end;

procedure createnewpackfile(var outputfile: file; var packfile: vfs_header_rec;
  creator: ansistring = 'djunique'; filename: ansistring = '');
begin
  assignfile(outputfile, filename);
  rewrite(outputfile, 1);
  packfile.offset_to_files := 0;
  packfile.numfiles := 0;
  packfile.timestamp := now;
  packfile.creator := creator;
  packfile.packfilename := filename;
  packfile.offset_to_files := sizeof(packfile) + length(creator);
  packfile.globaloffset := 0;
end;

procedure consoleoutputnoln(thestr: ansistring);
begin
  if isconsole = True then
  begin
    Write(thestr);
  end
  else
  begin
    if thestr <> '' then
      logfile.Add(datetimetostr(now) + ': ' + thestr);
    if console_output <> nil then
      console_output.Text := console_output.Text + thestr;
  end;
end;

procedure silentoutput(thestr: ansistring);
begin

  if thestr <> '' then
    logfile.Add(datetimetostr(now) + ': ' + thestr);

end;

procedure consoleoutput(thestr: ansistring);
begin
  if isconsole = True then
  begin
    writeln(thestr);
  end
  else
  begin
    if thestr <> '' then
      logfile.Add(datetimetostr(now) + ': ' + thestr);
    if console_output <> nil then
      console_output.Text := console_output.Text + thestr + #13#10;
  end;
end;

procedure writeheader(var outputfile: file; packfile: vfs_header_rec);
var
  t: integer;
  datablocksize: longint;
  tempfilestr: ansistring;
  cur_offset: integer;
  md5offsetmarker: integer;
  i, offsetmarker: integer;
  temp_input: file;
begin
  consoleoutputnoln('Writing header...');
  md5textfile := TStringList.Create;
  md5textfile.add('; VFSManager log file');
  md5textfile.add('; -------------------');
  md5textfile.add('; md5 checksum for ' + packfile.packfilename);
  md5textfile.add('; created: ' + datetimetostr(packfile.timestamp));
  md5textfile.add('; creator: ' + packfile.creator);
  blockwrite(
    outputfile, signature, sizeof(signature));
  blockwrite(outputfile, packfile.numfiles, 4);
  offsetmarker := filepos(outputfile);
  blockwrite(outputfile, packfile.offset_to_files, 4);
  writestring(outputfile, packfile.creator);
  writestring(outputfile, packfile.packdescription);
  writestring(outputfile, packfile.packfilename);
  blockwrite(outputfile, packfile.timestamp, sizeof(tdatetime));
  md5textfile.add(';filename,md5,size_compressed,size_uncompressed,offset');
  for t := 0 to packfile.numfiles - 1 do
  begin
    blockwrite(outputfile, packfile.files[t].md5checksum, sizeof(tmd5digest));
    md5textfile.add(format('%s,%s,%d,%d,%d',
      [extractfilename(packfile.files[t].filename),
      lowercase(md5digesttostr(packfile.files[t].md5checksum)),
      packfile.files[t].size_compressed, packfile.files[t].size_uncompressed,
      packfile.files[t].file_offset]));
  end;
  for t := 0 to packfile.numfiles - 1 do
  begin
    blockwrite(
      outputfile, packfile.files[t].filenamelength, 4);
    writestringnolength(outputfile, packfile.files[t].filename);
    blockwrite(outputfile, packfile.files[t].file_date, sizeof(tdatetime));
    blockwrite(outputfile, packfile.files[t].file_added, sizeof(tdatetime));
    blockwrite(outputfile, packfile.files[t].file_offset, 4);
    blockwrite(outputfile, packfile.files[t].file_compressed, 1);
    blockwrite(outputfile, packfile.files[t].size_compressed, 4);
    blockwrite(outputfile, packfile.files[t].size_uncompressed, 4);
  end;
  packfile.offset_to_files := filepos(outputfile);
  cur_offset := filepos(outputfile);
  seek(outputfile, offsetmarker);
  blockwrite(outputfile, packfile.offset_to_files, 4);
  seek(
    outputfile, cur_offset);
  assignfile(temp_input, windowstemp + '\vfs_temp.tmp');
  reset(temp_input, 1);
  //  md5textfile.savetofile(changefileext(packfile.packfilename, '.md5'));
  bufcount := returnfilesize(windowstemp + '\vfs_temp.tmp') div buffersize;
  lastbuf  := returnfilesize(windowstemp + '\vfs_temp.tmp') mod buffersize;
  if bufcount > 0 then
  begin
    for i := 0 to bufcount - 1 do
    begin
      blockread(temp_input, buf, sizeof(buf), numread);
      blockwrite(outputfile, buf, numread, numwritten);
    end;
  end;
  if lastbuf > 0 then
  begin
    blockread(temp_input, buf, lastbuf, numread);
    blockwrite(outputfile, buf, numread, numwritten);
  end;
  closefile(temp_input);
  consoleoutput('done!');
  deletefile(pwidechar(windowstemp + '\vfs_temp.tmp'));
end;

procedure closevfshandle(var outputfile: file);
begin
  closefile(outputfile);
end;

procedure addfileswithwildcard(var packfile: vfs_header_rec; pattern: ansistring;
  var numfound: integer; recursive: boolean = True);
var
  t: integer;
  list: TStrings;
begin
  list := TStringList.Create;
  if recursive = True then
    advbuildfilelist(pattern, fanormalfile, list, amany,
      [flfullnames, flrecursive])
  else
    advbuildfilelist(pattern, fanormalfile, list, amany,
      [flfullnames]);

  for t := 0 to list.Count - 1 do
  begin
    if (isdirectory(list[t]) = False) and (list[t] <> '.') and
      (list[t] <> '..') and (fileexists(list[t])) then
     begin
      add_file_to_vfs(packfile, list[t]);
     end;

  end;
  numfound := list.Count;
  list.Free;
end;

function compress_(filename: ansistring; compressionratio: tzcompressionlevel): longint;
begin
  src_stream  := tfilestream.Create(filename, fmopenread);
  dest_stream :=
    tfilestream.Create(extractfilename(filename) + '.zlib', fmcreate);
  compressor  := tzcompressionstream.Create(dest_stream, compressionratio);
  try
    compressor.copyfrom(src_stream, 0);
  finally
    begin
      if fileexists(filename) then
      begin
      end;
      compressor.Free;
      Result := dest_stream.size;
      src_stream.Free;
      dest_stream.Free;
    end;
  end;
end;

begin
  logfile := TStringList.Create;
  logfile.add('-(VFS Engine log)-------------');
  logfile.add(datetimetostr(now) + ': VFSP packfile engine initialized.');
  logfile.add('-----------------------------------------');

  windowstemp := getenvironmentvariable('TEMP');
end.

