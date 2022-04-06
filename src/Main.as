
void ExtractReplay()
{
    try
    {
        CGameDataFileManagerScript@ dataFileMgr = GetApp().PlaygroundScript.DataFileMgr;
        string outputFileName = "Downloaded/ValidationReplay_" + StripFormatCodes(GetApp().RootMap.MapName) + ".Replay.Gbx";
        CGameGhostScript@ authorGhost = dataFileMgr.Map_GetAuthorGhost(GetApp().RootMap);
        if (authorGhost is null)
        {
            throw("Author ghost is empty");
        }

        CWebServicesTaskResult@ taskResult = dataFileMgr.Replay_Save(outputFileName, GetApp().RootMap, authorGhost);
        if (taskResult is null)
        {
            throw("Replay task returned null");
        }

        while (taskResult.IsProcessing) { yield(); }
        if (!taskResult.HasSucceeded)
        {
            throw("Error while saving replay " + taskResult.ErrorDescription);
        }

        string outputMessage = "Replay extracted to: " + outputFileName;
        trace(outputMessage);
        UI::ShowNotification("Extract Validation Replay", outputMessage, 10000);
    }
    catch
    {
        string errorMessage = "Error occurred when trying to extract replay: " + getExceptionInfo();
        error(errorMessage);
        UI::ShowNotification("Extract Validation Replay", errorMessage, vec4(0.3, 0.0, 0.0, 0.5), 10000);
    }
}

void RenderMenu()
{
    if (!Permissions::CreateLocalReplay()) return;
    if (UI::MenuItem("\\$65f" + Icons::ShareSquareO + "\\$z Extract Validation Replay", enabled: GetApp().RootMap !is null))
    {
        startnew(ExtractReplay);
    }
}
