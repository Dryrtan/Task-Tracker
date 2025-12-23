program Task_Tracker;

{$APPTYPE CONSOLE}

{$R *.res}

uses
   System.SysUtils,
   System.IOUtils,
   TaskTracker.Types in 'TaskTracker.Types.pas',
   TaskTracker.Manager in 'TaskTracker.Manager.pas',
   TaskTracker.Language in 'TaskTracker.Language.pas';

var
   TaskManager: TTaskManager;

procedure ShowHelp;
begin
   Writeln('');
   Writeln(Lang.GetText('app_title_1'));
   Writeln(Lang.GetText('app_title_2'));
   Writeln(Lang.GetText('app_title_3'));
   Writeln(Lang.GetText('app_title_4'));
   Writeln(Lang.GetText('app_title_5'));
   Writeln(Lang.GetText('app_title_6'));
   Writeln('');
   Writeln('');
   Writeln(Lang.GetText('commands'));
   Writeln('');
   Writeln(Lang.GetText('cmd_add'));
   Writeln(Lang.GetText('cmd_update'));
   Writeln(Lang.GetText('cmd_delete'));
   Writeln(Lang.GetText('cmd_mark_progress'));
   Writeln(Lang.GetText('cmd_mark_done'));
   Writeln(Lang.GetText('cmd_list'));
   Writeln(Lang.GetText('cmd_list_todo'));
   Writeln(Lang.GetText('cmd_list_progress'));
   Writeln(Lang.GetText('cmd_list_done'));
   Writeln(Lang.GetText('cmd_lang'));
   Writeln('');
end;

procedure PrintTask(ATask: TTask);
begin
   Writeln(Format('[%d] %s - %s: %s', [ATask.Id, ATask.Description, Lang.GetText('status'), ATask.StatusToString]));
   Writeln(Format('    %s: %s | %s: %s',
      [Lang.GetText('created'), DateTimeToStr(ATask.CreatedAt), 
       Lang.GetText('updated'), DateTimeToStr(ATask.UpdatedAt)]));
end;

procedure HandleAdd(const ADescription: string);
var
   TaskId: Integer;
begin
   if ADescription.IsEmpty then
   begin
      Writeln(Lang.GetText('error_empty_desc'));
      Exit;
   end;

   TaskId := TaskManager.AddTask(ADescription);
   Writeln(Format(Lang.GetText('success_task_added'), [TaskId]));
end;

procedure HandleUpdate(AId: Integer; const ADescription: string);
begin
   if ADescription.IsEmpty then
   begin
      Writeln(Lang.GetText('error_empty_desc'));
      Exit;
   end;

   if TaskManager.UpdateTask(AId, ADescription) then
      Writeln(Lang.GetText('success_task_updated'))
   else
      Writeln(Lang.GetText('error_task_not_found'));
end;

procedure HandleDelete(AId: Integer);
begin
   if TaskManager.DeleteTask(AId) then
      Writeln(Lang.GetText('success_task_deleted'))
   else
      Writeln(Lang.GetText('error_task_not_found'));
end;

procedure HandleMarkInProgress(AId: Integer);
begin
   if TaskManager.MarkInProgress(AId) then
      Writeln(Lang.GetText('success_marked_progress'))
   else
      Writeln(Lang.GetText('error_task_not_found'));
end;

procedure HandleMarkDone(AId: Integer);
begin
   if TaskManager.MarkDone(AId) then
      Writeln(Lang.GetText('success_marked_done'))
   else
      Writeln(Lang.GetText('error_task_not_found'));
end;

procedure HandleList(const AFilter: string);
var
   Tasks: TArray<TTask>;
   Task: TTask;
   Status: TTaskStatus;
begin
   if AFilter.IsEmpty or (AFilter = 'all') then
      Tasks := TaskManager.ListAllTasks
   else
   begin
      Status := TTask.StringToStatus(AFilter);
      Tasks := TaskManager.ListTasksByStatus(Status);
   end;

   if Length(Tasks) = 0 then
   begin
      Writeln(Lang.GetText('no_tasks_found'));
      Exit;
   end;

   Writeln('');
   Writeln(Lang.GetText('tasks_header'));
   for Task in Tasks do
   begin
      PrintTask(Task);
      Writeln('');
   end;
end;

procedure HandleLanguage(const ALanguageCode: string);
var
   LangName: string;
begin
   if ALanguageCode = 'pt' then
   begin
      Lang.SetLanguage(lgPortuguese);
      LangName := 'Português';
   end
   else if ALanguageCode = 'en' then
   begin
      Lang.SetLanguage(lgEnglish);
      LangName := 'English';
   end
   else
   begin
      Writeln(Lang.GetText('invalid_language'));
      Exit;
   end;

   Writeln(Format(Lang.GetText('language_changed'), [LangName]));
end;

procedure ProcessCommand;
var
   Command: string;
   TaskId: Integer;
begin
   if ParamCount = 0 then
   begin
      ShowHelp;
      Exit;
   end;

   Command := LowerCase(ParamStr(1));

   if Command = 'add' then
   begin
      if ParamCount < 2 then
         Writeln(Lang.GetText('error_missing_desc'))
      else
         HandleAdd(ParamStr(2));
   end
   else
      if Command = 'update' then
      begin
         if ParamCount < 3 then
            Writeln(Lang.GetText('error_missing_id_desc'))
         else
         begin
            TaskId := StrToIntDef(ParamStr(2), -1);
            if TaskId = -1 then
               Writeln(Lang.GetText('error_invalid_id'))
            else
               HandleUpdate(TaskId, ParamStr(3));
         end;
      end
      else
         if Command = 'delete' then
         begin
            if ParamCount < 2 then
               Writeln(Lang.GetText('error_missing_id'))
            else
            begin
               TaskId := StrToIntDef(ParamStr(2), -1);
               if TaskId = -1 then
                  Writeln(Lang.GetText('error_invalid_id'))
               else
                  HandleDelete(TaskId);
            end;
         end
         else
            if Command = 'mark-in-progress' then
            begin
               if ParamCount < 2 then
                  Writeln(Lang.GetText('error_missing_id'))
               else
               begin
                  TaskId := StrToIntDef(ParamStr(2), -1);
                  if TaskId = -1 then
                     Writeln(Lang.GetText('error_invalid_id'))
                  else
                     HandleMarkInProgress(TaskId);
               end;
            end
            else
               if Command = 'mark-done' then
               begin
                  if ParamCount < 2 then
                     Writeln(Lang.GetText('error_missing_id'))
                  else
                  begin
                     TaskId := StrToIntDef(ParamStr(2), -1);
                     if TaskId = -1 then
                        Writeln(Lang.GetText('error_invalid_id'))
                     else
                        HandleMarkDone(TaskId);
                  end;
               end
               else
                  if Command = 'list' then
                  begin
                     if ParamCount >= 2 then
                        HandleList(ParamStr(2))
                     else
                        HandleList('');
                  end
                  else
                     if Command = 'lang' then
                     begin
                        if ParamCount < 2 then
                           Writeln(Lang.GetText('invalid_language'))
                        else
                           HandleLanguage(LowerCase(ParamStr(2)));
                     end
                     else
                     begin
                        Writeln(Lang.GetText('error_unknown_command') + Command);
                        ShowHelp;
                     end;
end;

var
   TasksFilePath: string;
   ConfigFilePath: string;
begin
   try
      // Define o caminho dos arquivos no diretório do executável
      TasksFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'tasks.json');
      ConfigFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.json');

      // Inicializa o gerenciador de idiomas
      Lang := TLanguageManager.Create(ConfigFilePath);
      try
         TaskManager := TTaskManager.Create(TasksFilePath);
         try
            ProcessCommand;
         finally
            TaskManager.Free;
         end;
      finally
         Lang.Free;
      end;
   except
      on E: Exception do
      begin
         Writeln('Erro:  ' + E.Message);
         ExitCode := 1;
      end;
   end;
end.



