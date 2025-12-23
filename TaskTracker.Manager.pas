unit TaskTracker. Manager;

interface

uses
  System.SysUtils, System.Classes, System. Generics.Collections,
  System.JSON, TaskTracker.Types;

type
  TTaskManager = class
  private
    FTasks: TObjectList<TTask>;
    FFileName: string;
    function GetNextId: Integer;
    procedure LoadFromFile;
    procedure SaveToFile;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;

    function AddTask(const ADescription: string): Integer;
    function UpdateTask(AId: Integer; const ADescription:  string): Boolean;
    function DeleteTask(AId: Integer): Boolean;
    function MarkInProgress(AId: Integer): Boolean;
    function MarkDone(AId: Integer): Boolean;
    function GetTask(AId: Integer): TTask;
    function ListAllTasks: TArray<TTask>;
    function ListTasksByStatus(AStatus: TTaskStatus): TArray<TTask>;
  end;

implementation

uses
  System.IOUtils;

constructor TTaskManager.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
  FTasks := TObjectList<TTask>.Create(True);
  LoadFromFile;
end;

destructor TTaskManager.Destroy;
begin
  FTasks.Free;
  inherited;
end;

function TTaskManager.GetNextId: Integer;
var
  Task: TTask;
  MaxId: Integer;
begin
  MaxId := 0;
  for Task in FTasks do
    if Task.Id > MaxId then
      MaxId := Task.Id;
  Result := MaxId + 1;
end;

procedure TTaskManager.LoadFromFile;
var
  JSONStr: string;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  Task: TTask;
  I: Integer;
begin
  FTasks.Clear;

  if not TFile.Exists(FFileName) then
    Exit;

  JSONStr := TFile. ReadAllText(FFileName);
  if JSONStr. Trim. IsEmpty then
    Exit;

  JSONArray := TJSONObject.ParseJSONValue(JSONStr) as TJSONArray;
  try
    if Assigned(JSONArray) then
    begin
      for I := 0 to JSONArray.Count - 1 do
      begin
        Task := TTask.Create;
        Task.FromJSON(JSONArray. Items[I] as TJSONObject);
        FTasks.Add(Task);
      end;
    end;
  finally
    JSONArray.Free;
  end;
end;

procedure TTaskManager.SaveToFile;
var
  JSONArray: TJSONArray;
  Task: TTask;
begin
  JSONArray := TJSONArray.Create;
  try
    for Task in FTasks do
      JSONArray.AddElement(Task.ToJSON);
    TFile.WriteAllText(FFileName, JSONArray.ToJSON);
  finally
    JSONArray. Free;
  end;
end;

function TTaskManager.AddTask(const ADescription: string): Integer;
var
  Task:  TTask;
begin
  Task := TTask.Create;
  Task.Id := GetNextId;
  Task.Description := ADescription;
  Task.Status := tsTodo;
  Task.CreatedAt := Now;
  Task.UpdatedAt := Now;
  FTasks.Add(Task);
  SaveToFile;
  Result := Task.Id;
end;

function TTaskManager.UpdateTask(AId: Integer; const ADescription: string): Boolean;
var
  Task: TTask;
begin
  Result := False;
  Task := GetTask(AId);
  if Assigned(Task) then
  begin
    Task.Description := ADescription;
    Task.UpdatedAt := Now;
    SaveToFile;
    Result := True;
  end;
end;

function TTaskManager.DeleteTask(AId: Integer): Boolean;
var
  Task: TTask;
begin
  Result := False;
  Task := GetTask(AId);
  if Assigned(Task) then
  begin
    FTasks.Remove(Task);
    SaveToFile;
    Result := True;
  end;
end;

function TTaskManager.MarkInProgress(AId: Integer): Boolean;
var
  Task: TTask;
begin
  Result := False;
  Task := GetTask(AId);
  if Assigned(Task) then
  begin
    Task. Status := tsInProgress;
    Task.UpdatedAt := Now;
    SaveToFile;
    Result := True;
  end;
end;

function TTaskManager. MarkDone(AId:  Integer): Boolean;
var
  Task: TTask;
begin
  Result := False;
  Task := GetTask(AId);
  if Assigned(Task) then
  begin
    Task.Status := tsDone;
    Task.UpdatedAt := Now;
    SaveToFile;
    Result := True;
  end;
end;

function TTaskManager. GetTask(AId: Integer): TTask;
var
  Task: TTask;
begin
  Result := nil;
  for Task in FTasks do
    if Task.Id = AId then
      Exit(Task);
end;

function TTaskManager.ListAllTasks: TArray<TTask>;
begin
  Result := FTasks.ToArray;
end;

function TTaskManager.ListTasksByStatus(AStatus: TTaskStatus): TArray<TTask>;
var
  Task: TTask;
  List: TList<TTask>;
begin
  List := TList<TTask>.Create;
  try
    for Task in FTasks do
      if Task.Status = AStatus then
        List.Add(Task);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

end.
