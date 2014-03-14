{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fpgui_designer;

interface

uses
  fpg_designer, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('fpg_designer', @fpg_designer.Register);
end;

initialization
  RegisterPackage('fpgui_designer', @Register);
end.
