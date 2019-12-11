unit FileIOFunctions;

interface



procedure WriteStringNoLength(var f: file; Data: ansistring);
procedure WriteString(var f: file; Data: ansistring);
procedure ReadHeader(var f: file; Data: ansistring);
procedure ReadString(var f: file; var Data: ansistring);
procedure ReadStringWithLength(var f: file; len: integer; var Data: ansistring);

implementation

procedure WriteString(var f: file; Data: ansistring);
var
    t, len: integer;
    s: ansichar;
begin
    len := length(Data);
    BlockWrite(f, len, 4);
    for t := 1 to len do
        begin
        s := Data[t];
        BlockWrite(f, s, 1);
        end;
end;

procedure ReadHeader(var f: file; Data: ansistring);
var
    t: integer;
    temp: string;
    len: integer;
var
    s: char;
begin
    temp := '';

    for t := 1 to length(Data) do
        begin
          BlockRead(f, s, 1);
        temp := temp + s;
        end;
    if temp <> Data then
        begin
        //showmessage('Warning: Header mismatch! expected="' + Data + '"');
        end;

end;

procedure ReadStringWithLength(var f: file; len: integer; var Data: ansistring);
var
    t: integer;
    s: char;
begin
    Data := '';
    for t := 1 to len do
        begin
        BlockRead(f, s, 1);
        Data := Data + s;
        end;
end;

procedure ReadString(var f: file; var Data: ansistring);
var
    t: integer;
    len: integer;

    s: char;
    chars: array [0..4095] of ansichar;
begin
    Data := '';
    BlockRead(f, len, 4);
   // SetLength(chars,len+1);
   // for t := 1 to len do
    //    begin
    chars:='';
        BlockRead(f, chars, len);
    Data := chars;
  //  writeln('Read string: '+data);
    //    Data := Data + s;
      //  end;
end;

procedure WriteStringNoLength(var f: file; Data: ansistring);
var
    t, len: integer;
    s: ansichar;
begin
    len := length(Data);
//  BlockWrite(f, len, 4);
    for t := 1 to len do
        begin
        s := Data[t];
        BlockWrite(f, s, 1);
        end;
end;

end.

