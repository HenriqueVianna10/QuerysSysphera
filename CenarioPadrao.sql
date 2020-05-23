SELECT        CAST(txtApplication AS xml ).value('(/ApplicationStateVO/ScenarioCurrent)[1]', 'int') AS SK_CENARIO
FROM            REP_APPLICATION
WHERE        (codApplication = 1)