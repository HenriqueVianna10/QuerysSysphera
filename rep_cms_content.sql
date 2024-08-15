--select * from REP_CMS_CONTENT where dscName in ('DataFormDynamic_2293', 'DataFormDynamic_2547', 'DataFormDynamic_2646')
INSERT [dbo].[REP_CMS_IMAGE] ([dscName], [datImage], [datLastModified]) 
VALUES (N'Ok.png', 0x89504E470D0A1A0A0000000D494844520000000F0000000F08060000003BD6954A0000000473424954080808087C086488000000BE4944415428536364A0003052A09781BE9ACDE6B2EA9F4AFE7D11E462926CB65CC011C7F89F69E17FC67FF1C7137E2C225A33C8461626D6FD400B05C1E1F4F79F02519AD135A2D86C398FA3EED7EF1F13CFA6337C440F7D5C1AC17EB69CCF3517687DD2FFFF0CE77EFDFEE6846C003E8D10CDD0400071900D309EC9C0CFC6CAB58F9191C1082C070D24649781FD8C6E00E3BF7F41FF9998D6E1D3881255C806209B8ECD46983C4A68A31B804F23D644829E10F0A57DACF18C9C04F16906009B78730D9D8B08F80000000049454E44AE426082, CAST(N'2022-12-30T11:30:47.660' AS DateTime))


select *
from REP_CMS_CONTENT where dscName = 'DataFormDynamic_11250';


update REP_CMS_CONTENT
set	datLastModified = getdate(),
	dscContent = '
<div style="height: 100%;">
    <style type="text/css">     
         body {background-color:#F8F9FA}              
        .suWindowConteiner {padding: 17px 63px; }            
        .suWindowContainerEvolucao {background-color:#F8F9FA; height:100%;}            
        .suWindowConteiner .suWindowContent {background-color: #fff;border-radius: 4px 4px 0 0;margin-top: 15px;padding: 10px 20px 20px 20px;}
        .suWindowConteiner .suWindowContentFlexContainerRowHalf {width: 50%;}            
        .suWindowConteiner .suWindowContentFlexContainerRow {display: flex; flex-flow: row;}            
        .suWindowConteiner .suWindowContentFlexContainerRow .suWindowContentFlexContainerRowItem {width: 100%; margin-left: 20px;}            
        .suWindowConteiner .suWindowContentFlexContainerRow .suWindowContentFlexContainerRowItem label {font-size: 14px; font-weight: bold; color: #333333;}            
        .suWindowConteiner .suWindowContentFlexContainerRow .suWindowContentFlexContainerRowItem:first-child {margin-left: 0;}            
        .suWindowConteiner .suWindowContentFlexContainerRow .suWindowContentFlexContainerRowItem textarea {resize: none;}            
        .suWindowConteiner .suWindowContentFlexContainerRow .suWindowContentFlexContainerRowItem .suEvolucaoDisabledButton {border-color: #c1c1c1; pointer-events: none; color: #c1c1c1;}            
        .suWindowConteiner .suWindowContentFlexContainerRowMarginTop {margin-top: 20px;}            
        .suWindowConteiner .suWindowContentGrid {margin-top: 10px;}            
        .suWindowConteiner .suWindowContentGrid .suWindowContentGridHeader {background-color: #F7F7F7; display: flex;}            
        .suWindowConteiner .suWindowContentGridHeader .suWindowContentGridHeaderTitle {font-weight: bold; font-size: 0.75rem; color: #333333; border: 1px solid #ddd; padding: 6px 10px;}            
        .suWindowConteiner .suWindowContentGridCells {display: flex;}   
        .suWindowConteiner .suWindowContentGridCellsWarning {background-color: #FFF5CC; border:1px solid #FFD008;}  
        .suWindowConteiner .suWindowContentGridCellsDanger {background-color: #f19595; border:1px solid  #da0202;}           
        .suWindowConteiner .suWindowContentGridCells .suWindowContentGridCellsDatum {border-bottom: 1px solid #ddd; padding:0px 7px;line-height: 2.5;}            
        .suWindowConteiner .suWindowContentGridCells .suWindowContentGridCellDatumButton {cursor: pointer;}            
        .suWindowConteiner .suWindowContentGridCells .suWindowContentGridCellsDatumStatus {border-bottom: 1px solid #ddd; padding: 4px 10px;}            
        .suWindowConteiner .suWindowContentGridCells .suWindowContentGridCellsDatum:first-child {border-left: 1px solid #ddd;}            
        .suWindowConteiner .suWindowContentGridCells .suWindowContentGridCellsDatum:last-child {border-right: 1px solid #ddd;}            
        .suEvolucaoDisabled {background-color: #ededed; pointer-events: none;}                     
        .ppToView::before {content: "\00B0"}                     
        .suEvolucaoButtonsBox {width: 590px; font-size: 12px; color: #333; border: 1px solid #DDDDDD; border-radius: 4px; background-color: #F8F9FA; padding: 20px 20px;}            
        .suWindowContainerEvolucao .suWindowContent.suWindowContentBoxFinal {margin-top: 0; border-radius: 0 0 4px 4px;}                            
        .suWindowContainerEvolucao input.ppFormControl {height: 28px;}   
        .suStatusIcon {margin-right: 8px; vertical-align: baseline; border-radius: 4px; padding: 6px;cursor: pointer; }   
        .suStatusIcon.suStatusWarning {background-color: #FFF5CC; color: #FDC729;}            
        .suStatusIcon.suStatusWarning::before {font-size: 16px;}           
        .suStatusIcon.suStatusDanger {background-color: #f19595; color: #da0202;}            
        .suStatusIcon.suStatusDanger::before {font-size: 16px;}     
        .suLogButton {display: flex;width: 15%; margin-bottom: 0px; justify-content: flex-end;align-items: flex-end;}
        .suLogButtonBorder {border: 1px solid #993333; border-radius: 4px; padding: 5px; cursor: pointer; background-color: #993333; color: white;}                              
    </style>
    <div class="ppCloak" d-cloak="ppCloak" style="height: 100%;">
        <div d-dataKey="worksheetSector" d-dataType="value"></div>
        <div d-dataKey="worksheetSectorProcesso" d-dataType="value"></div>
        <div d-dataKey="table" d-dataType="object"></div>
        <div d-dataKey="tableProcesso" d-dataType="object"></div>
        <div d-dataKey="tableStatus" d-dataType="value"></div>
        <div d-dataKey="codigoProcesso" d-dataType="value"></div>
        <div d-dataKey="gatilhoValue" d-dataType="value"></div>
        <div d-dataKey="windowUserConfiguration" d-dataType="object" d-dataUrlGet="~/api/User/GetUserConfiguration"></div>
        <div d-datakey="panelWorkflowStarterObjectData" d-datatype="object" d-dataloadtype="startup" d-dataurlget="~/api/Workflow/GetProcessStarter?code={{gatilhoValue}}&amp;viewMode=true"></div>
        <div d-datakey="panelWorkFlowStarterFinishFunction" d-datatype="value" d-dataloadtype="startup" d-datavalue="UpdateData(panelWorkflowStarterInstance,{{panelWorkflowStarterObjectData}});PostDataItem(panelWorkflowStarterInstance)"></div>
        <div d-datakey="panelWorkflowStarterInstance" d-datatype="object" d-dataurlset="~/api/Workflow/StartProcessInstance"></div>
        <div d-dataKey="windowExecuteTrigger" d-dataType="value" d-dataValue="UpdateData(codigoProcesso,{{table.Pages.[0].Value}});ExecuteDataItem(UpdateData(gatilhoValue,{{rows.Cells.[2].Value}}),rows in tableProcesso.Rows[1..^0],({{rows.Cells.[0].Value}}={{codigoProcesso}}));"></div>
        <div style="display: none;">
            <d-worksheet dc-mode="source" dc-sourcedatakey="table" dc-sourceautosave="false" dc-polling="true" dc-pollingtimespan="100" dc-sourceallowemptypage="true" dc-sector="worksheetSector" dc-type="dataform" dc-typecode="11250" dc-instancecode="" dc-sourcestatus="{{tableStatus}}"></d-worksheet>
            <d-worksheet dc-mode="source" dc-sourcedatakey="tableProcesso" dc-sourceautosave="false" dc-sourceallowemptypage="true" dc-sector="worksheetSectorProcesso" dc-type="dataform" dc-typecode="11249" dc-instancecode=""></d-worksheet>
        </div>
        <div class="suWindowConteiner suWindowContainerEvolucao">
            <div class="suWindowContent">
                <div class="suWindowContentFlexContainerRow suWindowContentFlexContainerRowMarginTop">
                    <div class="suWindowContentFlexContainerRowItem">
                        <label d-model="Processo"></label>                          
                        <d-dropdowntree d-class="{form-control,ppFormControl,suEvolucaoDisabled:{{Pages.[0].IsReadOnly}}}" dc-dataKey="table" dc-prefix="Pages.[0].Nodes" dc-hierarchy="Nodes" dc-key="Value" dc-value="Label" dc-model="{{table.Pages.[0].Value}}"></d-dropdowntree>
                    </div>
                    <div d-class="{suLogButton}">
                        <div class="ppRainbowButton, suLogButtonBorder" d-attr-value="{{word.Finish}}" d-on-click="Execute({{windowExecuteTrigger}});{{panelWorkFlowStarterFinishFunction}}">   
                            <div class="pp ppWorkflowStarter" style="padding: 5px;"></div><span>Executar Processo</span>
                        </div>
                    </div>
                </div>
                <div class="suWindowContentFlexContainerRowMarginTop">
                    <div class="suWindowContentGrid">
                        <div class="suWindowContentGridHeader"> 
                            <span class="suWindowContentGridHeaderTitle suColumn2" d-model="Grupo"></span> 
                            <span class="suWindowContentGridHeaderTitle suColumn7" d-model="Descrição"></span> 
                            <span class="suWindowContentGridHeaderTitle suColumn1" d-model="Status"></span> 
                            <span class="suWindowContentGridHeaderTitle suColumn2" d-model="Data e Hora"></span> 
                        </div>
                        <div>
                            <div d-class="{suWindowContentGridCells,suWindowContentGridCellsWarning:{{row.Cells.[3].Value}}=A,suWindowContentGridCellsDanger:{{row.Cells.[3].Value}}=E}" d-for="row in table.Rows" d-if="(({{row._Index}}>0))">
                                <span class="suWindowContentGridCellsDatum suColumn2" d-model="{{row.Cells.[1].Value}}"></span>            
                                <span class="suWindowContentGridCellsDatum suColumn7" d-model="{{row.Cells.[2].Value}}"></span>    
                                <div class="suWindowContentGridCellsDatum suColumn1">  
                                    <a d-attr-href="{{row.Cells.[4].Value}}" target="_blank">
									<span d-if="{{row.Cells.[3].Value}}=A" class="suStatusIcon suStatusWarning pp ppNotificationImageerror" d-attr-title="Ação" placeholder="Acessar Link" title="Acessar Link"></span>                               
                                    <span d-if="{{row.Cells.[3].Value}}=E" class="suStatusIcon suStatusDanger pp ppNotificationImageerror" d-attr-title="Erro" placeholder="Acessar Link" title="Acessar Link" d-on-click="RedirectPage({{row.Cells.[5].Value}});UpdateItemField({{row.Current}},true)"></span>                                                                  
                                    <img d-if="{{row.Cells.[3].Value}}=I" class="suStatusIcon" d-attr-src="~/api/CMS/GetImage?id=Ok.png" d-attr-title="Concluí­do" d-attr-alt="Concluí­do"/> 
									</a>  
                                </div>        
                                <span class="suWindowContentGridCellsDatum suColumn2" d-model="{{row.Cells.[0].Value}}" d-format="G" d-format-timezone="false"></span>         
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div d-if="{{tableStatus}}!=" class="suWindowContentStatus"> 
                <span>Status: </span>
                <span d-model={{tableStatus}}></span> 
            </div>
        </div>
    </div>
</div>
'
where codContent = 133