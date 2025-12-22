unit TaskTracker.Types;

interface

uses
  System.SysUtils, System. Generics.Collections, System.JSON;

type
  TTaskStatus = (tsNone, tsTodo, tsInProgress, tsDone);

  TTask = class
  private
    FId:  Integer;
    FDescription: string;
    FStatus: TTaskStatus;
    FCreatedAt:  TDateTime;
    FUpdatedAt: TDateTime;
  public
    property Id: Integer read FId write FId;
    property Description: string read FDescription write FDescription;
    property Status:  TTaskStatus read FStatus write FStatus;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;

    function ToJSON: TJSONObject;
    procedure FromJSON(AJSONObject: TJSONObject);
    function StatusToString: string;
    class function StringToStatus(const AStatus: string): TTaskStatus;
  end;

implementation

function TTask.ToJSON:  TJSONObject;
begin
  Result := TJSONObject. Create;
  Result.AddPair('id', TJSONNumber. Create(FId));
  Result.AddPair('description', FDescription);
  Result.AddPair('status', StatusToString);
  Result.AddPair('createdAt', DateTimeToStr(FCreatedAt));
  Result.AddPair('updatedAt', DateTimeToStr(FUpdatedAt));
end;

procedure TTask.FromJSON(AJSONObject: TJSONObject);
begin
  FId := AJSONObject.GetValue<Integer>('id');
  FDescription := AJSONObject.GetValue<string>('description');
  FStatus := StringToStatus(AJSONObject.GetValue<string>('status'));
  FCreatedAt := StrToDateTime(AJSONObject.GetValue<string>('createdAt'));
  FUpdatedAt := StrToDateTime(AJSONObject.GetValue<string>('updatedAt'));
end;

function TTask.StatusToString: string;
begin
  case FStatus of
    tsTodo: Result := 'todo';
    tsInProgress: Result := 'in-progress';
    tsDone: Result := 'done';
  else
    Result := 'todo';
  end;
end;

class function TTask.StringToStatus(const AStatus: string): TTaskStatus;
begin
  if AStatus = 'todo' then
    Result := tsTodo
  else if AStatus = 'in-progress' then
    Result := tsInProgress
  else if AStatus = 'done' then
    Result := tsDone
  else
    Result := tsTodo;
end;

end.
