classdef demo1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        TabGroup                matlab.ui.container.TabGroup
        DataTab                 matlab.ui.container.Tab
        DataManagementPanel     matlab.ui.container.Panel
        LoadButton              matlab.ui.control.Button
        StandardizationButton   matlab.ui.control.Button
        DataViewPanel           matlab.ui.container.Panel
        FilepathEditFieldLabel  matlab.ui.control.Label
        FilepathEditField       matlab.ui.control.EditField
        UITable                 matlab.ui.control.Table
        Tab2                    matlab.ui.container.Tab
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            [filename,filepath] = uigetfile('*.*','Please select a file to import.');
            if filename
                app.FilepathEditField.Value = [filepath, filename];
                data = readtable([filepath,filename]);
                app.UITable.Data = data;
                app.UITable.ColumnName = data.Properties.VariableNames;
                msgbox('Data import is done!')                
                
                assignin('base','app',app) % assign 'app' to workspace
            end
        end

        % Button pushed function: StandardizationButton
        function StandardizationButtonPushed(app, event)
            data = app.UITable.Data;
            numdata = table2array(data(2:end,2:end));
            Z = zscore(numdata);
            data(2:end,2:end) = array2table(Z);
            app.UITable.Data = data;
            
            msgbox('Standardization is done!')
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [12 11 617 460];

            % Create DataTab
            app.DataTab = uitab(app.TabGroup);
            app.DataTab.Title = 'Data';

            % Create DataManagementPanel
            app.DataManagementPanel = uipanel(app.DataTab);
            app.DataManagementPanel.Title = 'Data Management';
            app.DataManagementPanel.FontWeight = 'bold';
            app.DataManagementPanel.FontSize = 14;
            app.DataManagementPanel.Position = [15 12 189 407];

            % Create LoadButton
            app.LoadButton = uibutton(app.DataManagementPanel, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.FontWeight = 'bold';
            app.LoadButton.Position = [19 350 153 23];
            app.LoadButton.Text = 'Load';

            % Create StandardizationButton
            app.StandardizationButton = uibutton(app.DataManagementPanel, 'push');
            app.StandardizationButton.ButtonPushedFcn = createCallbackFcn(app, @StandardizationButtonPushed, true);
            app.StandardizationButton.FontWeight = 'bold';
            app.StandardizationButton.Position = [18.5 300 154 23];
            app.StandardizationButton.Text = 'Standardization';

            % Create DataViewPanel
            app.DataViewPanel = uipanel(app.DataTab);
            app.DataViewPanel.Title = 'Data View';
            app.DataViewPanel.FontWeight = 'bold';
            app.DataViewPanel.FontSize = 14;
            app.DataViewPanel.Position = [215 12 386 407];

            % Create FilepathEditFieldLabel
            app.FilepathEditFieldLabel = uilabel(app.DataViewPanel);
            app.FilepathEditFieldLabel.HorizontalAlignment = 'right';
            app.FilepathEditFieldLabel.Position = [22 351 51 22];
            app.FilepathEditFieldLabel.Text = 'File path';

            % Create FilepathEditField
            app.FilepathEditField = uieditfield(app.DataViewPanel, 'text');
            app.FilepathEditField.Position = [88 351 280 22];

            % Create UITable
            app.UITable = uitable(app.DataViewPanel);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Position = [18 16 350 322];

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = demo1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end