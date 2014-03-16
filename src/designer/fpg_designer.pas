unit fpg_designer;

{$mode objfpc}{$H+}

interface

uses
  LCLProc, LCLType, Classes, SysUtils, FormEditingIntf, LCLIntf, Graphics,
  ProjectIntf, fpg_base, fpg_main, fpg_widget, fpg_form, fpg_edit, fpg_memo;

type

  { TfpgMediator }

  TfpgMediator = class(TDesignerMediator)
  private
    m_fpgForm: TfpgForm;
  public
    // needed by the lazarus form editor
    class function CreateMediator(TheOwner, aForm: TComponent): TDesignerMediator;
      override;
    class function FormClass: TComponentClass; override;
    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out
            CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ParentAcceptsChild(Parent: TComponent;
                Child: TComponentClass): boolean; override;
  public
    // needed by TfpgWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    property fpgForm: TfpgForm read m_fpgForm;
  end;


  { TFileDescPascalUnitWithFpgForm }

  TFileDescPascalUnitWithFpgForm = class(TFileDescPascalUnitWithResource)
  public
    constructor Create; override;
    function GetInterfaceUsesSection: string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;


procedure Register;

implementation

procedure Register;
begin
  FormEditingHook.RegisterDesignerMediator(TfpgMediator);
  RegisterComponents('Standard',[TfpgEdit, TfpgMemo]);
  RegisterProjectFileDescriptor(TFileDescPascalUnitWithFpgForm.Create,
                                FileDescGroupName);
end;

{ TFileDescPascalUnitWithFpgForm }

constructor TFileDescPascalUnitWithFpgForm.Create;
begin
  inherited Create;
  Name:='fpgForm';
  ResourceClass:=TfpgForm;
  UseCreateFormStatements:=false;
end;

function TFileDescPascalUnitWithFpgForm.GetInterfaceUsesSection: string;
begin
  Result:='Classes, SysUtils, fpg_base, fpg_main, fpg_form';
end;

function TFileDescPascalUnitWithFpgForm.GetLocalizedName: string;
begin
  Result:='fpgForm';
end;

function TFileDescPascalUnitWithFpgForm.GetLocalizedDescription: string;
begin
  Result:='Create a new fpgForm for fpgGUI Application';
end;




{ TfpgMediator }

class function TfpgMediator.CreateMediator(TheOwner, aForm: TComponent
  ): TDesignerMediator;

var
  Mediator: TfpgMediator;
begin
  Result:=inherited CreateMediator(TheOwner, aForm);
  Mediator:=TfpgMediator(Result);
  Mediator.m_fpgForm:=aForm as TfpgForm;
  Mediator.m_fpgForm.FormDesigner:=Mediator;
end;

class function TfpgMediator.FormClass: TComponentClass;
begin
  Result := TfpgForm;
end;

procedure TfpgMediator.GetBounds(AComponent: TComponent; out CurBounds: TRect);
var
  w: TfpgWidget;
begin
  if AComponent is TfpgWidget then
  begin
    w:=TfpgWidget(AComponent);
    CurBounds:=Bounds(w.Left,w.Top,w.Width,w.Height);
  end else
    inherited GetBounds(AComponent,CurBounds);
end;

procedure TfpgMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TfpgWidget then begin
    TfpgWidget(AComponent).SetPosition(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
  end else
    inherited SetBounds(AComponent,NewBounds);
end;

procedure TfpgMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
begin
  inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TfpgMediator.Paint;
begin
  m_fpgForm.Invalidate;
  inherited Paint;
end;

function TfpgMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=not (AComponent is TfpgWidget);
end;

function TfpgMediator.ParentAcceptsChild(Parent: TComponent;
  Child: TComponentClass): boolean;
begin
  Result:=(Parent is TfpgWidget) and TfpgWidget(Parent).IsContainer
     and Child.InheritsFrom(TfpgComponent);
    //and (TfpgWidget(Parent).AcceptChildsAtDesignTime);
end;

constructor TfpgMediator.Create(AOwner: TComponent);
begin
  //fpgApplication.Initialize;
  inherited Create(AOwner);
end;

destructor TfpgMediator.Destroy;
begin
  //if FMyForm<>nil then FMyForm.Designer:=nil;
  //FMyForm:=nil;

  inherited Destroy;
end;

end.

