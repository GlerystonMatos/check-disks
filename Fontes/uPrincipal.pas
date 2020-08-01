unit uPrincipal;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    btnVerificar: TBitBtn;
    mInfo: TMemo;
    procedure btnVerificarClick(Sender: TObject);
  private
    { Private declarations }
    function GetQtdDeMegabytesLivreEmDisco(drive: Byte): Double;
    function RoundOf(const aValue: extended; aDecimals: byte = 2): double;
    function GetUnidades: string;
    function GetWindowsDrive: Char;
    procedure LoadInfoDriver;
    procedure LoadInfoDriverCode;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnVerificarClick(Sender: TObject);
var
  qtdMegabytesLivre: Double;
begin
  mInfo.Lines.Clear;
  mInfo.Lines.Add('Unidades: ' + GetUnidades);
  mInfo.Lines.Add('O Windows está instalado na unidade: ' + GetWindowsDrive);
  mInfo.Lines.Add('');
  LoadInfoDriver;
  LoadInfoDriverCode;
  mInfo.Lines.Add('Verificação Disco Execução:');
  mInfo.Lines.Add('Espaço livre: ' + FloatToStr(GetQtdDeMegabytesLivreEmDisco(0)) + ' MB.');
  mInfo.Lines.Add('Espaço livre: ' + FloatToStr(GetQtdDeMegabytesLivreEmDisco(0) / 1024) + ' GB.');
  mInfo.Lines.Add('Tamanho do disco: ' + FloatToStr(DiskSize(0)) + ' MB.');
  mInfo.Lines.Add('Tamanho do disco: ' + FloatToStr(DiskSize(0) / 1024) + ' GB.');
end;

function TfrmPrincipal.RoundOf(const aValue: extended; aDecimals: byte): double;
var
  s: string;
  sBuffer: ShortString;
  e: integer;
begin
  Str(aValue: 18: aDecimals, sBuffer);
  try
    s := string(sBuffer);
    Val(s, Result, e);
  except
    Result := 0;
  end;
end;

function TfrmPrincipal.GetQtdDeMegabytesLivreEmDisco(drive: Byte): Double;
const
  UmMegaEmBytes = 1048576;
begin
  Result := RoundOf(DiskFree(drive) / UmMegaEmBytes, 0);
end;

function TfrmPrincipal.GetUnidades: string;
var
  Retorno: Cardinal;
  Unidades: array[0..104] of WideChar; { 26 * 4 + 1 bytes }
  Unidade: PWideChar;
begin
  Result := '';
  Retorno := GetLogicalDriveStrings(SizeOf(Unidades) - 1, Unidades);
  if Retorno > 0 then
  begin
    Unidade := Unidades;
    while Unidade^ <> #0 do
    begin
      if Result <> '' then
        Result := Result + #13;
      Result := Result + ', ' + string(Unidade);
      Inc(Unidade, 4);
    end;
  end
  else
    RaiseLastOSError;
end;

function TfrmPrincipal.GetWindowsDrive: Char;
var
  Buffer: string;
begin
  SetLength(Buffer, MAX_PATH);
  if GetWindowsDirectory(PChar(Buffer), MAX_PATH) > 0 then
    Result := string(Buffer)[1]
  else
    Result := #0;
end;

procedure TfrmPrincipal.LoadInfoDriver;
var
  NomeVolume, NomeSistemaArquivo: PChar;
  Serial, NomeArquivoMax, Flags: DWORD;
  total, livre: Int64;

  Retorno: Cardinal;
  Unidades: array[0..104] of WideChar; { 26 * 4 + 1 bytes }
  Unidade: PWideChar;

  I: Integer;
begin
  Retorno := GetLogicalDriveStrings(SizeOf(Unidades) - 1, Unidades);
  if Retorno > 0 then
  begin
    Unidade := Unidades;
    I := 0;
    while Unidade^ <> #0 do
    begin
      GetMem(NomeVolume, MAX_PATH);
      GetMem(NomeSistemaArquivo, MAX_PATH);
      try
        GetVolumeInformation(PWideChar(string(Unidade)), NomeVolume, MAX_PATH, @Serial, NomeArquivoMax, Flags, NomeSistemaArquivo, MAX_PATH);
        mInfo.Lines.Add('Volume: ' + string(Unidade));
        mInfo.Lines.Add('Codigo: ' + IntToStr(I));
        mInfo.Lines.Add('Nome do volume (label): ' + string(NomeVolume));
        mInfo.Lines.Add('Número serial: ' + IntToHex(Serial, 8));
        mInfo.Lines.Add('Nome arquivo máximo: ' + IntToStr(NomeArquivoMax));
        mInfo.Lines.Add('Sistema de arquivos: ' + string(NomeSistemaArquivo));
        mInfo.Lines.Add('');
      finally
        FreeMem(NomeVolume, MAX_PATH);
        FreeMem(NomeSistemaArquivo, MAX_PATH);
      end;
      Inc(I);
      Inc(Unidade, 4);
    end;
  end
  else
    RaiseLastOSError;
end;

procedure TfrmPrincipal.LoadInfoDriverCode;
var
  Drives: DWord;
  I: Byte;
begin
  Drives := GetLogicalDrives;
  if Drives <> 0 then
  begin
    for I := 0 to 25 do { A..Z }
    begin
      if (Drives and (1 shl I) <> 0) and (DiskSize(I) > 0) then
      begin
        mInfo.Lines.Add('Volume: ' + Char(65 + I));
        mInfo.Lines.Add('Codigo: ' + IntToStr(I));
        mInfo.Lines.Add('Espaço livre: ' + FloatToStr(GetQtdDeMegabytesLivreEmDisco(I)) + ' MB.');
        mInfo.Lines.Add('Espaço livre: ' + FloatToStr(GetQtdDeMegabytesLivreEmDisco(I) / 1024) + ' GB.');
        mInfo.Lines.Add('Tamanho do disco: ' + FloatToStr(DiskSize(I)) + ' MB.');
        mInfo.Lines.Add('Tamanho do disco: ' + FloatToStr(DiskSize(I) / 1024) + ' GB.');
        mInfo.Lines.Add('');
      end;
    end;
  end;
end;

end.
