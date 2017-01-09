function opcMainJFrame()
import java.awt.*;
import javax.swing.*;

fig = figure;
fig.Visible = 'off';

da = 0;
grp = 0;
dbtimer = 0;

summerTempCounter = 0;
summerNightCooling = false;
timerPeriod = 30;                                                           % timer stores value every 30 seconds and logs to .txt file every 5 minutes

counter = 0;
roomComfortZone = 0;

roomTempArry = zeros(1, 10);
co2Arry = zeros(1, 10);
humidityArry = zeros(1, 10);
wallTempArry = zeros(1, 10);
glassTempArry = zeros(1, 10);
concreteTempArry = zeros(1, 10);
luxArry = zeros(1, 10);
heatingArry = zeros(1, 10);
lightArry = zeros(1, 10);
equipArry = zeros(1, 10);
peopleArry = zeros(1, 10);

roofTempArry = zeros(1, 10);
windSpeedArry = zeros(1, 10);
windDirArry = zeros(1, 10);
sunIIIsouthArry = zeros(1, 10);

refTempArry = zeros(1, 10);
refConcTempArry = zeros(1, 10);
refCo2Arry = zeros(1, 10);
refHumidityArry = zeros(1, 10);

cavTempBottomArry = zeros(1, 10);
cavTempCenterArry = zeros(1, 10);
cavTempTopArry = zeros(1, 10);

outdoorTempArry = zeros(1, 10);
outdoorSolarRadDiffArry = zeros(1, 10);
outdoorSolarRadGloArry = zeros(1, 10);
outdoorWindSpeedArry = zeros(1, 10);
outdoorWindDirArry = zeros(1, 10);

roomComfortLow = false;
roomComfortHigh = false;
roomCavityCmp = false;
roomOutdoorCmp = false;
cavityOutdoorCmp = false;
cavityComfortHighCmp = false;
co2Flag = false;
theta = 1.0;

frame = JFrame('OPC DA Client Data Logging and Room Temperature Regulator');

%   Positions the application to be in the middle of the screen
frame.setLocationByPlatform(true);

%   connect tab Panels
allTabPanel = JPanel();
allTabPanel.setLayout(BorderLayout());
drawnow;

%   Overview Tab
overviewTabPanel = JPanel();
overviewTabPanel.setLayout(GridBagLayout());

gCon = GridBagConstraints();
gCon.weightx = 0.5;
gCon.weighty = 0.1;

%   Time row
overTimeLabel = JLabel('Time :');
gCon.gridy = 0;
gCon.gridx = 0;
gCon.insets = Insets(10, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(overTimeLabel, gCon);

transparentBorder = BorderFactory.createLineBorder(Color.gray, 0);

overTimeField = JTextField(15);
overTimeField.setEditable(false);
overTimeField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(10, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(overTimeField, gCon);

overviewTabPanel.add(JSeparator(), gCon);

%   outdoor temperature row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 1;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Outdoor Temperature : '), gCon);

outdoorField = JTextField(15);
outdoorField.setEditable(false);
outdoorField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(outdoorField, gCon);

%   comfort zone temperature row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 2;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Comfort Zone Temperature : '), gCon);

comfortZoneField = JTextField(15);
comfortZoneField.setEditable(false);
comfortZoneField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(comfortZoneField, gCon);
overviewTabPanel.add(javax.swing.JSeparator(SwingConstants.VERTICAL));

%   indoor Temperature row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 3;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Indoor Temperature : '), gCon);

indoorField = JTextField(15);
indoorField.setEditable(false);
indoorField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(indoorField, gCon);

gCon.weightx = 2.0;
gCon.gridx = 2;
gCon.insets = Insets(0, 0, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
inStatusField = JTextField(20);
inStatusField.setEditable(false);
inStatusField.setFont(java.awt.Font('Serif', Font.ITALIC, 16));
inStatusField.setBorder(transparentBorder);
overviewTabPanel.add(inStatusField, gCon);

%   Cavity row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 4;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Cavity Temperature : '), gCon);

cavityTopTempField = JTextField(15);
cavityTopTempField.setEditable(false);
cavityTopTempField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(cavityTopTempField, gCon);
overviewTabPanel.add(javax.swing.JSeparator(SwingConstants.VERTICAL));

%   CO2 row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 5;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('CO2 : '), gCon);

co2OverField = JTextField(15);
co2OverField.setEditable(false);
co2OverField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(co2OverField, gCon);

gCon.weightx = 2.0;
gCon.gridx = 2.0;
gCon.insets = Insets(0, 0, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
co2StatusField = JTextField(15);
co2StatusField.setEditable(false);
co2StatusField.setFont(java.awt.Font('Serif', Font.ITALIC, 16));
co2StatusField.setBorder(transparentBorder);
overviewTabPanel.add(co2StatusField, gCon);

%   Humidity row
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 6;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Humidity : '), gCon);

humidityOverField = JTextField(15);
humidityOverField.setEditable(false);
humidityOverField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(humidityOverField, gCon);

%   summer night cooling status
gCon.weightx = 0.5;
gCon.weighty = 0.1;
gCon.gridy = 7;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Summer Night Cooling Status : '), gCon);

nightOverField = JTextField(15);
nightOverField.setEditable(false);
nightOverField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(nightOverField, gCon);

%   current time of overheating
gCon.weightx = 0.5;
gCon.weighty = 1.0;
gCon.gridy = 8;
gCon.gridx = 0;
gCon.insets = Insets(0, 0, 0, 10);
gCon.anchor = GridBagConstraints.FIRST_LINE_END;
overviewTabPanel.add(JLabel('Current Time of Overheating : '), gCon);

currentHeatField = JTextField(15);
currentHeatField.setEditable(false);
currentHeatField.setBorder(transparentBorder);
gCon.gridx = 1;
gCon.insets = Insets(0, 20, 0, 0);
gCon.anchor = GridBagConstraints.FIRST_LINE_START;
overviewTabPanel.add(currentHeatField, gCon);

%   End of Overview Tab

%   Begin Configure Tab
configureTabPanel = JPanel();
configureTabPanel.setLayout(GridBagLayout);
gc = GridBagConstraints();

%   allowed warm room max time
overheatingLabel = javax.swing.JLabel('Acceptable Time of Overheating : ');
gc.weightx = 1.0;
gc.weighty = 0.1;
gc.gridy = 0;
gc.gridx = 0;
gc.insets = Insets(0, 0, 0, 10);
gc.anchor = GridBagConstraints.LINE_END;
configureTabPanel.add(overheatingLabel, gc);

overheatingField = javax.swing.JTextField(10);
overheatingField.setText('1');
userDefinedOverheatingVal = str2double(overheatingField.getText());
gc.gridx = 1;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.LINE_START;
configureTabPanel.add(overheatingField, gc);

%   Umrechnung der Nutzereingabe von [h] in [s] und Anpassung an den
%   verwendeten TimeStep
counterLimit = (userDefinedOverheatingVal * 60 * 60)/(timerPeriod * 10);

gc.weightx = 10.0;
gc.gridx = 2;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.LINE_START;
configureTabPanel.add( javax.swing.JLabel('[Hours/days]'), gc);

%   concrete limit SNC
concreteLabel = javax.swing.JLabel('Concrete Temperature Limit for "SUMMER NIGHT COOLING" : ');
gc.weightx = 1.0;
gc.weighty = 1.0;
gc.gridy = 1;
gc.gridx = 0;
gc.insets = Insets(0, 0, 0, 10);
gc.anchor = GridBagConstraints.LINE_END;
configureTabPanel.add(concreteLabel, gc);

concreteField = javax.swing.JTextField(10);
concreteField.setText('18');
userDefinedConcreteVal = str2double(concreteField.getText());
gc.gridx = 1;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.LINE_START;
configureTabPanel.add(concreteField, gc);

gc.weightx = 10.0;
gc.gridx = 2;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.LINE_START;
configureTabPanel.add( javax.swing.JLabel(' [°C] '), gc);

%   global radiation Limit for shading
globalRadLabel = javax.swing.JLabel('Radiation limit for shading default value : ');
gc.weightx = 1.0;
gc.weighty = 1.0;
gc.gridy = 2;
gc.gridx = 0;
gc.insets = Insets(0, 0, 0, 10);
gc.anchor = GridBagConstraints.FIRST_LINE_END;
configureTabPanel.add(globalRadLabel, gc);

globalRadField = javax.swing.JTextField(10);
globalRadField.setText('300');
userDefinedglobalRadiationVal = str2double(globalRadField.getText());
gc.gridx = 1;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.FIRST_LINE_START;
configureTabPanel.add(globalRadField, gc);

gc.weightx = 10.0;
gc.gridx = 2;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.FIRST_LINE_START;
configureTabPanel.add( javax.swing.JLabel(' [W/m2] '), gc);

%   user defined update button
gc.weightx = 1.0;
gc.weighty = 4.1;
gc.gridy = 3;
gc.gridx = 1;
gc.insets = Insets(0, 0, 0, 0);
gc.anchor = GridBagConstraints.FIRST_LINE_START;
updateBtn = JButton('Update Data');
configureTabPanel.add(updateBtn, gc);
set(updateBtn, 'MouseReleasedCallback', @userOverWrite);

%   End Configure Tab

%   table Tab
roomDataPanel = JPanel();
roomDataPanel.setLayout(BorderLayout);

%   Table Panel
drawnow;
roomTableModel = javax.swing.table.DefaultTableModel();
roomTable = JTable(roomTableModel);

roomTableModel.addColumn('TimeStamp');
roomTableModel.addColumn('Temperature [°C]');
roomTableModel.addColumn('CO2 [ppm]');
roomTableModel.addColumn('Humidity [%]');
roomTableModel.addColumn('Wall Temperature [°C]');
roomTableModel.addColumn('Glass Temperature [°C]');
roomTableModel.addColumn('Concrete Temperature [°C]');
roomTableModel.addColumn('Illuminance [lux]');
roomTableModel.addColumn('High Temp Counter');

roomTableScroll = JScrollPane(roomTable);
roomTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
roomTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
roomDataPanel.add(roomTableScroll);

% Energy Panel
energyDataPanel = JPanel();
energyDataPanel.setLayout(BorderLayout);

drawnow;
energyTableModel = javax.swing.table.DefaultTableModel();
energyTable = JTable(energyTableModel);

energyTableModel.addColumn('TimeStamp');
energyTableModel.addColumn('Heating Power [W]');
energyTableModel.addColumn('Lightning Power [W]');
energyTableModel.addColumn('Equipment Power [W]');                          % Ans: 0/4/18 - 0/4/6
energyTableModel.addColumn('People');

energyTableScroll = JScrollPane(energyTable);
energyTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
energyTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
energyDataPanel.add(energyTableScroll);

%   Roof Table
roofDataPanel = JPanel();
roofDataPanel.setLayout(BorderLayout);

roofTableModel = javax.swing.table.DefaultTableModel();
roofTable = JTable(roofTableModel);

roofTableModel.addColumn('Timestamp');
roofTableModel.addColumn('Temperature [°C]');
roofTableModel.addColumn('Wind Speed [m/s]');
roofTableModel.addColumn('Wind Direction [°]');
roofTableModel.addColumn('Sun Illuminance South [lux]');


roofTableScroll = JScrollPane(roofTable);
roofTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
roofTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
roofDataPanel.add(roofTableScroll);

%   Ref Table
refDataPanel = JPanel();
refDataPanel.setLayout(BorderLayout);

refTableModel = javax.swing.table.DefaultTableModel();
refTable = JTable(refTableModel);

refTableModel.addColumn('Timestamp');
refTableModel.addColumn('Temperature [°C]');
refTableModel.addColumn('Concrete Temperature [°C]');
refTableModel.addColumn('CO2 [ppm]');
refTableModel.addColumn('Humidity [%]');

refTableScroll = JScrollPane(refTable);
refTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
refTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
refDataPanel.add(refTableScroll);

%   Cavity Table

cavDataPanel = JPanel();
cavDataPanel.setLayout(BorderLayout);

cavTableModel = javax.swing.table.DefaultTableModel();
cavTable = JTable(cavTableModel);

cavTableModel.addColumn('Timestamp');
cavTableModel.addColumn('Bottom Temperature [°C]');
cavTableModel.addColumn('Center Temperature [°C]');
cavTableModel.addColumn('Top Temperature [°C]');
cavTableModel.addColumn('Indoor Windows [%]');
cavTableModel.addColumn('Outdoor Windows [%]');
cavTableModel.addColumn('Bypass Windows [%]');

cavTableScroll = JScrollPane(cavTable);
cavTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
cavTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
cavDataPanel.add(cavTableScroll);

% Outdoor Table
outDataPanel = JPanel();
outDataPanel.setLayout(BorderLayout);

outTableModel = javax.swing.table.DefaultTableModel();
outTable = JTable(outTableModel);

outTableModel.addColumn('Timestamp');
outTableModel.addColumn('Temperature [°C]');
outTableModel.addColumn('Solar Radiation diffuse [W/m2]');
outTableModel.addColumn('Solar Radiation global [W/m2]');
outTableModel.addColumn('Wind Speed [m/s]');
outTableModel.addColumn('Wind Direction [°]');

outTableScroll = JScrollPane(outTable);
outTableScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
outTableScroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
outDataPanel.add(outTableScroll);

drawnow;
%   end of table Panel

%   end of Connect tab Panel

%   Connect Status Panel
connectPanel = JPanel();
connectPanel.setBorder(BorderFactory.createEtchedBorder());

%   Status information
statusLabel = javax.swing.JLabel('Current Status');
statusField = JTextField(10);
statusField.setEditable(false);
statusField.setText('disconnected');

onOFFStatus = JLabel('•');
onOFFStatus.setFont(Font(Font.MONOSPACED, Font.BOLD, 25));
onOFFStatus.setForeground(java.awt.Color.red);

connectPanel.setLayout(FlowLayout(FlowLayout.RIGHT, 60, 5));
connectPanel.add(statusLabel);
connectPanel.add(statusField);
connectPanel.add(onOFFStatus);
%   End of Connect Panel

%   console Text Area Panel

%   This provides a scrolling capacity for the text area with the default scroll bar policy.
%   By default, the vertical scroll bar only appears when the display area is entirely filled with text and there is no room to append new words.
consoleArea = JTextArea();
consoleArea.setWrapStyleWord(true);
consoleArea.setEditable(false);
consoleArea.setRows(5);
consoleArea.setBorder(BorderFactory.createEtchedBorder());

%   End of console Text Area Panel

    function addItems(hObject, callbackdata)
        %   Adding Office Sensors
        roomTemp = additem(grp, {'ZoneData.Temperature.1/0/51'});
        co2 = additem(grp, {'ZoneData.CO2.1/1/51'});
        roomHumidity = additem(grp, {'ZoneData.Humidity.1/2/51'});
        wallSurfaceTemp = additem(grp, {'ZoneData.Temperature.1/0/65'});
        glassTemp = additem(grp, {'ZoneData.Temperature.1/0/66'});
        concreteTemp = additem(grp, {'ZoneData.Temperature.1/0/62'});
        lux = additem(grp, {'CommonData.WeatherData_Research.0/3/21'});
        heatingPower = additem(grp, {'CommonData.Energy_Research.0/4/38'});
        lightningPower = additem(grp, {'CommonData.Energy_Research.0/4/6'});
        totalPower = additem(grp, {'CommonData.Energy_Research.0/4/18'});
        
        pers1 = additem(grp, {'ZoneData.Anwesenheit.1/7/1'});
        pers2 = additem(grp, {'ZoneData.Anwesenheit.1/7/2'});
        pers3 = additem(grp, {'ZoneData.Anwesenheit.1/7/3'});
        pers4 = additem(grp, {'ZoneData.Anwesenheit.1/7/4'});
        pers5 = additem(grp, {'ZoneData.Anwesenheit.1/7/5'});
        pers6 = additem(grp, {'ZoneData.Anwesenheit.1/7/6'});
        pers7 = additem(grp, {'ZoneData.Anwesenheit.1/7/7'});
        pers8 = additem(grp, {'ZoneData.Anwesenheit.1/7/8'});
        
        %   Building Roof
        roofTemp = additem(grp, {'CommonData.WeatherData.0/0/1'});
        roofWindSpeed = additem(grp, {'CommonData.WeatherData.0/0/2'});
        roofWindDir = additem(grp, {'CommonData.WeatherData.0/0/3'});
        roofSunLux = additem(grp, {'CommonData.WeatherData.0/0/11'});
        
        %   Reference room
        refTemp = additem(grp, {'ZoneData.Temperature.1/0/53'});
        refConcreteTemp = additem(grp, {'ZoneData.Temperature.1/0/63'});
        refCO2 = additem(grp, {'ZoneData.CO2.1/1/53'});
        refHumidity = additem(grp, {'ZoneData.Humidity.1/2/53'});
        
        %   Cavity
        CavityTempBottom = additem(grp, {'ZoneData.Temperature.1/0/56'});
        CavityTempCenter = additem(grp, {'ZoneData.Temperature.1/0/57'});
        CavityTempTop = additem(grp, {'ZoneData.Temperature.1/0/58'});
        
        %   Outdoor (infront of the facade)
        outdoorTemp = additem(grp, {'CommonData.WeatherData_Research.0/3/25'});
        outSolarRadDiff = additem(grp, {'CommonData.WeatherData_Research.0/3/24'});
        outSolarRadGlo = additem(grp, {'CommonData.WeatherData_Research.0/3/23'});
        outdoorWind = additem(grp, {'CommonData.WeatherData_Research.0/3/8'});
        outdoorWindDir = additem(grp, {'CommonData.WeatherData_Research.0/3/3'});
        
        %   Motors
        IndoorMotorA = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/32'});
        IndoorMotorB = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/33'});
        IndoorMotorC = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/34'});
        
        OutdoorMotorA = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/45'});
        OutdoorMotorB = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/46'});
        OutdoorMotorC = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/47'});
        OutdoorMotorD = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/40'});
        OutdoorMotorE = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/41'});
        OutdoorMotorF = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/42'});
        
        byPassMotorA = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/36'});
        byPassMotorB = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/43'});
        byPassMotorC = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/35'});
        byPassMotorD = additem(grp, {'MotorLineDataWEC161-192.AutoPositionCommand.9/1/44'});
        
        %   Window Master NV
        startStop = additem(grp, {'CommonData.General_Research.0/5/3'});
        
        %   Windows max position
        maxPosition01 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/32'});
        maxPosition02 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/33'});
        maxPosition03 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/34'});
        maxPosition04 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/35'});
        maxPosition05 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/36'});
        maxPosition06 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/37'});
        maxPosition07 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/38'});
        maxPosition08 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/39'});
        maxPosition09 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/40'});
        maxPosition10 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/41'});
        maxPosition11 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/42'});
        maxPosition12 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/43'});
        maxPosition13 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/44'});
        maxPosition14 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/45'});
        maxPosition15 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/46'});
        maxPosition16 = additem(grp, {'MotorLineDataWEC161-192.MaxPositionCommand.9/0/47'});
        
        readIndoor = additem(grp, {'MotorLineDataWEC161-192.ActualPosition.9/5/34'});
        readOutdoor = additem(grp, {'MotorLineDataWEC161-192.ActualPosition.9/5/42'});
        readbyPass = additem(grp, {'MotorLineDataWEC161-192.ActualPosition.9/5/43'});
        
    end

%   tabulates only 48 hours of the previously stored data
    function minimizeTableRows(hObject, callbackdata)
        rowTotal = roomTableModel.getRowCount();
        maximumRow = (60 * 48) / 5;         % (60 minutes * 48 hours) / 5 minutes
        
        if rowTotal >= maximumRow
            roomTableModel.removeRow(0);
            energyTableModel.removeRow(0);
            roofTableModel.removeRow(0);
            refTableModel.removeRow(0);
            outTableModel.removeRow(0);
            cavTableModel.removeRow(0);
        end
    end

%   open or close windows
    function operateWindows(startItem, endItem, controlAction)
        for i = startItem:endItem
            write(grp.Item(i), controlAction);
        end
    end

%   maintain room's temperature in the Comfort Room Zone
    function comfortZoneCalculator(hObject, callbackdata)
        
        currentCO2 =  mean(co2Arry);
        currentOutdoorTemp = mean(roofTempArry);
        currentRoomTemp = mean(roomTempArry);
        currentConcreteTemp = mean(refConcTempArry);
        currentCavityTemp = mean(cavTempTopArry);                           % top Cavity Temperature is chosen
        
        minimizeTableRows();
        operateWindows(49, 64, 100);                                        % Update the value of MaxPositionCommand to 100
        
        %   Comfort Zone Temperature Calculation
        if currentOutdoorTemp >= 16 && currentOutdoorTemp <= 32
            roomComfortZone = 18 + (0.25 * currentOutdoorTemp);
        elseif currentOutdoorTemp < 16
            roomComfortZone = 22;
        elseif currentOutdoorTemp > 32
            roomComfortZone = 26;
        end
        
        %   Determine current comparison between each medium
        if currentRoomTemp < (roomComfortZone - theta)                      % Lower Comfort Boundary
            roomComfortLow = true;
            inStatusField.setText('Room temperature is cold');
            inStatusField.setForeground(java.awt.Color.red);
        else
            roomComfortLow = false;
            inStatusField.setText('Room temperature is normal');
            inStatusField.setForeground(java.awt.Color.green);
        end
        
        if currentRoomTemp > (roomComfortZone + theta)                      % Upper Comfort Boundary
            roomComfortHigh = true;
            inStatusField.setText('Room temperature is warm');
            inStatusField.setForeground(java.awt.Color.red);
        else
            roomComfortHigh = false;
            inStatusField.setText('Room temperature is normal');
            inStatusField.setForeground(java.awt.Color.green);
        end
        
        if currentRoomTemp > currentCavityTemp
            roomCavityCmp = true;
        else
            roomCavityCmp = false;
        end
        
        if currentRoomTemp > currentOutdoorTemp
            roomOutdoorCmp = true;
        else
            roomOutdoorCmp = false;
        end
        
        if currentCavityTemp > currentOutdoorTemp
            cavityOutdoorCmp = true;
        else
            cavityOutdoorCmp = false;
        end
        
        if currentCavityTemp > roomComfortZone - theta
            cavityComfortHighCmp = true;
        else
            cavityComfortHighCmp = false;
        end
        
        %   Summer Night Cooling Indicator
        if roomComfortHigh && ~summerNightCooling
            summerTempCounter = summerTempCounter + 1;
        end
        
        if (summerTempCounter >= counterLimit) && ~summerNightCooling
            summerNightCooling = true;
        end
        
        if (hour(datetime('now')) == 9) || ((currentConcreteTemp <= userDefinedConcreteVal) && summerNightCooling)   % at 9:00 every day reset SNC counter
            summerNightCooling = false;
            summerTempCounter = 0;
        end
        
        %   Cases Implementation
        if currentCO2 >= 900
            co2Flag = true;
            co2StatusField.setText('Too much CO2..');
            co2StatusField.setForeground(java.awt.Color.red);
            
            if roomCavityCmp
                if cavityOutdoorCmp
                    operateWindows(35, 37, 100);                            % open inner windows
                    operateWindows(44, 47, 0);                              % close bypass windows
                else
                    co2WindowsOperate();
                end
            else
                if ~cavityOutdoorCmp
                    operateWindows(35, 37, 100);                            % open inner windows
                    operateWindows(44, 47, 0);                              % close bypass windows
                else
                    co2WindowsOperate();
                end
            end
            
            outerWindowOperate();
            
        elseif co2Flag && (currentCO2 > 500)
            
            if ~roomOutdoorCmp
                operateWindows(44, 47, 0);                                  % close bypass windows
            else
                operateWindows(44, 47, 100);                                % open bypass windows
            end
            
            if roomComfortHigh && roomCavityCmp
                operateWindows(35, 37, 100);                                % open inner windows
            else
                operateWindows(35, 37, 0);                                  % close inner windows
            end
            outerWindowOperate();
            
        elseif ~summerNightCooling
            
            co2Flag = false;
            
            co2StatusField.setText('CO2 is normal..');
            co2StatusField.setForeground(java.awt.Color.green);
            
            if roomComfortHigh
                
                if roomOutdoorCmp
                    operateWindows(44, 47, 100);                            % open bypass windows
                else
                    operateWindows(44, 47, 0);                              % close bypass windows
                end
                
                if roomCavityCmp
                    operateWindows(35, 37, 100);                            % open inner windows
                else
                    operateWindows(35, 37, 0);                              % close inner windows
                end
            elseif roomComfortLow
                
                if roomOutdoorCmp
                    operateWindows(44, 47, 0);                              % close bypass windows
                end
                
                if roomCavityCmp
                    operateWindows(35, 37, 0);                              % close inner windows
                end
            end
            
            outerWindowOperate();
            
        elseif summerNightCooling
            
            co2Flag = false;
            
            co2StatusField.setText('CO2 is normal..');
            co2StatusField.setForeground(java.awt.Color.green);
            
            inStatusField.setText('Summer Night Cooling is in effect.....');
            inStatusField.setForeground(java.awt.Color.blue);
            
            if (currentConcreteTemp > userDefinedConcreteVal)               % too cold summers
                if roomOutdoorCmp
                    operateWindows(44, 47, 100);                            % open bypass windows
                else
                    operateWindows(44, 47, 0);                              % close bypass windows
                end
                
                if roomCavityCmp
                    operateWindows(35, 37, 100);                            % open inner windows
                else
                    operateWindows(35, 37, 0);                              % close inner windows
                end
                
            else
                operateWindows(44, 47, 0);                                  % close bypass windows
                operateWindows(35, 37, 0);                                  % close inner windows
            end
            
            if cavityOutdoorCmp
                operateWindows(38, 43, 100);                                % open outer windows
            else
                operateWindows(38, 43, 0);                                  % close outer windows
            end
            
        else
            operateWindows(35, 47, 0);                           % close all windows
            disp('Testing Phase');
            inStatusField.setText('This case has not been defined.');
            co2StatusField.setText('This case has not been defined.');
            inStatusField.setForeground(java.awt.Color.pink);
            co2StatusField.setForeground(java.awt.Color.pink);
            consoleArea.append([sprintf('\n'), 'This case has not been defined. Please note down this case scenario and report to the developer.', sprintf('\n')]);
        end
    end

    function dataChangeCallback(hObject, callbackdata)
        drawnow;
    end

    function outerWindowOperate()
        if cavityComfortHighCmp && cavityOutdoorCmp
            operateWindows(38, 43, 100);                                    % open outer windows
        else
            operateWindows(38, 43, 0);                                      % close outer windows
        end
    end

    function co2WindowsOperate()
        if roomOutdoorCmp
            operateWindows(35, 37, 0);                                      % close inner windows
            operateWindows(44, 47, 100);                                    % open bypass windows
        else
            operateWindows(35, 37, 100);                                    % open inner windows
            operateWindows(44, 47, 0);                                      % close bypass windows
        end
    end

    function dbLogger(hObject, callbackdata)
        
        %   Calculate the Average (Mean) of the 10 values read
        meanRoomTemp = num2str(mean(roomTempArry), '% 10.2f');
        meanCO2 = num2str(mean(co2Arry), '% 10.2f');
        meanHumidity = num2str(mean(humidityArry), '% 10.2f');
        meanWallTemp = num2str(mean(wallTempArry), '% 10.2f');
        meanGlassTemp = num2str(mean(glassTempArry), '% 10.2f');
        meanConcreteTemp = num2str(mean(concreteTempArry), '% 10.2f');
        meanLUX = num2str(mean(luxArry), '% 10.2f');
        
        timeStamp = datestr(datetime('now'));
        
        fileIdRoom = fopen('dbRoomFile.txt', 'a');
        nbytesRoom = fprintf(fileIdRoom, '%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanRoomTemp, meanCO2, meanHumidity, meanWallTemp, meanGlassTemp, meanConcreteTemp, meanLUX, num2str(summerTempCounter));
        fclose(fileIdRoom);
        
        grpDataRoom = {timeStamp, meanRoomTemp, meanCO2, meanHumidity, meanWallTemp, meanGlassTemp, meanConcreteTemp, meanLUX, summerTempCounter};
        roomTableModel.insertRow(roomTableModel.getRowCount(), grpDataRoom);
        
        %   Logging Energy for room reading
        meanHeating = num2str(mean(heatingArry), '% 10.2f');
        meanLight = num2str(mean(lightArry), '% 10.2f');
        meanEquip = num2str(mean(equipArry), '% 10.2f');
        meanPerson = num2str(mean(peopleArry), '% 10.2f');
        
        fileIdEnergy = fopen('dbEnergyFile.txt', 'a');
        nbytesEnergy = fprintf(fileIdEnergy, '%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanHeating, meanLight, meanEquip, meanPerson);
        fclose(fileIdEnergy);
        
        grpDataEnergy = {timeStamp, meanHeating, meanLight, meanEquip, meanPerson};
        energyTableModel.insertRow(energyTableModel.getRowCount(), grpDataEnergy);
        
        %   Logging Data for Roof Reading
        meanRoofTemp = num2str(mean(roofTempArry), '% 10.2f');
        meanWindSpeed = num2str(mean(windSpeedArry), '% 10.2f');
        meanWindDir = num2str(mean(windDirArry), '% 10.2f');
        meanSunIII = num2str(mean(sunIIIsouthArry), '% 10.2f');
        
        fileIdRoof = fopen('dbRoofFile.txt', 'a');
        nbytesRoof = fprintf(fileIdRoof, '%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanRoofTemp, meanWindSpeed, meanWindDir, meanSunIII);
        fclose(fileIdRoof);
        
        grpDataRoof = {timeStamp, meanRoofTemp, meanWindSpeed, meanWindDir, meanSunIII};
        roofTableModel.insertRow(roofTableModel.getRowCount(), grpDataRoof);
        
        %   Logging Data for reference room Readings
        meanRefTemp = num2str(mean(refTempArry), '% 10.2f');
        meanRefConcTemp = num2str(mean(refConcTempArry), '% 10.2f');
        meanRefCo2 = num2str(mean(refCo2Arry), '% 10.2f');
        meanRefHumidity = num2str(mean(refHumidityArry), '% 10.2f');
        
        fileIdRef = fopen('dbRefFile.txt', 'a');
        nbytesRef = fprintf(fileIdRef, '%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanRefTemp, meanRefConcTemp, meanRefCo2, meanRefHumidity);
        fclose(fileIdRef);
        
        grpDataRef = {timeStamp, meanRefTemp, meanRefConcTemp, meanRefCo2, meanRefHumidity};
        refTableModel.insertRow(refTableModel.getRowCount(), grpDataRef);
        
        %   Logging Data for Cavity readings
        meanCavTempBottom = num2str(mean(cavTempBottomArry), '% 10.2f');
        meanCavTempCenter = num2str(mean(cavTempCenterArry), '% 10.2f');
        meanCavTempTop = num2str(mean(cavTempTopArry), '% 10.2f');
        meanIndoorVal = read(grp.Item(65));
        meanOutdoorVal = read(grp.Item(66));
        meanBypassVal = read(grp.Item(67));
        
        fileIdCav = fopen('dbCavFile.txt', 'a');
        nbytesCav = fprintf(fileIdCav, '%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanCavTempBottom, meanCavTempCenter, meanCavTempTop, num2str(meanIndoorVal.Value), num2str(meanOutdoorVal.Value), num2str(meanBypassVal.Value));
        fclose(fileIdCav);
        
        grpDataCav = {timeStamp, meanCavTempBottom, meanCavTempCenter, meanCavTempTop, num2str(meanIndoorVal.Value), num2str(meanOutdoorVal.Value), num2str(meanBypassVal.Value)};
        cavTableModel.insertRow(cavTableModel.getRowCount(), grpDataCav);
        
        %   Logging data for Outdoor Readings
        meanOutdoorTemp = num2str(mean(outdoorTempArry), '% 10.2f');
        meanOutdoorSolarRadDiff = num2str(mean(outdoorSolarRadDiffArry), '% 10.2f');
        meanOutdoorSolarRadGlo = num2str(mean(outdoorSolarRadGloArry), '% 10.2f');
        meanOutdoorWindSpeed = num2str(mean(outdoorWindSpeedArry), '% 10.2f');
        meanOutdoorWindDir = num2str(mean(outdoorWindDirArry), '% 10.2f');
        
        fileIdOut = fopen('dbOutFile.txt', 'a');
        nbytesOut = fprintf(fileIdOut, '%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', timeStamp, meanOutdoorTemp, meanOutdoorSolarRadDiff, meanOutdoorSolarRadGlo, meanOutdoorWindSpeed, meanOutdoorWindDir);
        fclose(fileIdOut);
        
        grpDataOut = {timeStamp, meanOutdoorTemp, meanOutdoorSolarRadDiff, meanOutdoorSolarRadGlo, meanOutdoorWindSpeed, meanOutdoorWindDir};
        outTableModel.insertRow(outTableModel.getRowCount(), grpDataOut);
        
        comfortZoneCalculator();                                            % Comfort Room Zone
        
        %   Clear data in array of size 10 to value 0 (reset)
        roomTempArry = zeros(1, 10);
        co2Arry = zeros(1, 10);
        humidityArry = zeros(1, 10);
        wallTempArry = zeros(1, 10);
        glassTempArry = zeros(1, 10);
        concreteTempArry = zeros(1, 10);
        luxArry = zeros(1, 10);
        heatingArry = zeros(1, 10);
        lightArry = zeros(1, 10);
        equipArry = zeros(1, 10);
        peopleArry = zeros(1, 10);
        
        roofTempArry = zeros(1, 10);
        windSpeedArry = zeros(1, 10);
        windDirArry = zeros(1, 10);
        sunIIIsouthArry = zeros(1, 10);
        
        refTempArry = zeros(1, 10);
        refConcTempArry = zeros(1, 10);
        refCo2Arry = zeros(1, 10);
        refHumidityArry = zeros(1, 10);
        
        cavTempBottomArry = zeros(1, 10);
        cavTempCenterArry = zeros(1, 10);
        cavTempTopArry = zeros(1, 10);
        
        outdoorTempArry = zeros(1, 10);
        outdoorSolarRadDiffArry = zeros(1, 10);
        outdoorSolarRadGloArry = zeros(1, 10);
        outdoorWindSpeedArry = zeros(1, 10);
        outdoorWindDirArry = zeros(1, 10);
        
        %   Convert SNC to boolean
        if summerNightCooling
            summerTemp = 'True';
        else
            summerTemp = 'False';
        end
        
        %   Acceptable time duration for room to be warm
        hourTemp = num2str((summerTempCounter * 10 * timerPeriod) / (60 * 60), '% 10.2f');
        
        %   Overview Tab Panel update
        overTimeField.setText(strcat( {'     '},timeStamp));
        outdoorField.setText(strcat( {'     '}, meanRoofTemp, {' °C'}));
        comfortZoneField.setText(strcat( {'     '}, num2str(roomComfortZone, '% 10.2f'), {' °C'}));
        indoorField.setText(strcat( {'     '}, meanRoomTemp, {' °C'}));
        cavityTopTempField.setText(strcat( {'     '}, meanCavTempTop, {' °C'}));
        co2OverField.setText(strcat( {'     '}, meanCO2, {' ppm'}));
        humidityOverField.setText(strcat( {'     '}, meanHumidity, {' %'}));
        nightOverField.setText(strcat( {'     '}, summerTemp));
        currentHeatField.setText(strcat( {'     '}, hourTemp, {' Hours'}));
        
    end

%   Connect OPC
    function connectOPC(hObject, callbackdata)
        %   check if OPC DA object already exist before creating a new one
        da = opcda('localhost', 'WMaEIBOPCServer');
        connect(da);
        
        grp = addgroup(da, 'CallbackTest');
        statusField.setText(char(da.Status));
        consoleArea.append([sprintf('\n'), '... ' ,char(da.Status), ' ...', sprintf('\n')]);
        pause(1);
        
        addItems();                                                         % add items to the group
        write(grp.Item(48), true);                                          % set WindowMasterNV to TRUE
        onOFFStatus.setForeground(java.awt.Color.green);
        
        operateWindows(49, 64, 100)                                         % Update the value of MaxPositionCommand to 100
        createDBFiles();
        
        %   To constantly poll for the current values of the sensors that change dynamically
        grp.dataChangeFcn = @dataChangeCallback;                            %   data change event
        
        da.ShutDownFcn = @shutDownCallback;
        
        %   Timer for database
        dbtimer = timer;
        dbtimer.ExecutionMode = 'fixedRate';
        dbtimer.Period = timerPeriod;
        dbtimer.TimerFcn = @timerCallback;
        dbtimer.BusyMode = 'queue';
        
        start(dbtimer);
        drawnow;
    end

    function shutDownCallback(hObject, callbackdata)
        el = da.EventLog;
        
        disconnectOPC();
        
        consoleArea.setForeground(java.awt.Color.red);
        consoleArea.append([sprintf('\n'),'Type of Event : ', el.Type]);
        consoleArea.append([sprintf('\n'),'Local Time of Event : ', datestr(datetime(el.Data.LocalEventTime))]);
        consoleArea.append([sprintf('\n'),'Reason of Event ', el.Type, ' : ', el.Data.Reason]);
        consoleArea.append([sprintf('\n'), 'Please report to WindowMaster for assistance', sprintf('\n')]);
    end

    function createDBFiles(hObject, callbackdata)
        %   check database if files do not exist then create new ones with header
        if exist('dbCavFile.txt', 'file') ~= 2
            fileIDCav = fopen('dbCavFile.txt', 'w');
            fprintf(fileIDCav,'%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Bottom Temperature', 'Center Temperature', 'Top Temperature', 'Indoor Windows', 'Outdoor Windows', 'Bypass Windows');
            fclose(fileIDCav);
        end
        
        if exist('dbEnergyFile.txt', 'file') ~= 2
            fileIDEn = fopen('dbEnergyFile.txt', 'w');
            fprintf(fileIDEn,'%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Heating Power', 'Lightning Power', 'Equipment Power', 'People');
            fclose(fileIDEn);
        end
        
        if exist('dbOutFile.txt', 'file') ~= 2
            fileIDout = fopen('dbOutFile.txt', 'w');
            fprintf(fileIDout,'%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Temperature', 'Solar Rad Diffuse', 'Solar Rad Global', 'Wind Speed', 'Wind Direction');
            fclose(fileIDout);
        end
        
        if exist('dbRefFile.txt', 'file') ~= 2
            fileIDref = fopen('dbRefFile.txt', 'w');
            fprintf(fileIDref,'%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Temperature', 'Concrete Temperature', 'CO2', 'Humidity');
            fclose(fileIDref);
        end
        
        if exist('dbRoofFile.txt', 'file') ~= 2
            fileIDroof = fopen('dbRoofFile.txt', 'w');
            fprintf(fileIDroof,'%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Temperature', 'Wind Speed', 'Wind Direction', 'Sun Illuminance South');
            fclose(fileIDroof);
        end
        
        if exist('dbRoomFile.txt', 'file') ~= 2
            fileIDroom = fopen('dbRoomFile.txt', 'w');
            fprintf(fileIDroom,'%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\t%20s\r\n', 'Timestamp', 'Temperature', 'CO2', 'Humidity', 'Wall Temperature', 'Glass Temperature', 'Concrete Temperature', 'Illuminance', 'High Temp Counter');
            fclose(fileIDroom);
        end
    end

%   Disconnect OPC
    function disconnectOPC(hObject, callbackdata)
        
        if isa(dbtimer, 'timer') || strcmp(dbtimer.Running, 'on')
            stop(dbtimer);
        end
        
        if isa(da, 'opcda') && strcmp(da.STATUS, 'connected')
            write(grp.Item(48), false);                                     % set WindowMasterNV to false
            disconnect(da);
            statusField.setText(char(da.Status));
            consoleArea.append([sprintf('\n'), '... ' ,char(da.Status), ' ...', sprintf('\n')]);
            onOFFStatus.setForeground(java.awt.Color.red);
        end
        
        pause(1);
        drawnow;
    end

    function userOverWrite(hObject, callbackdata)
        %   Read all active items in group
        refresh(grp);
        
        userDefinedOverheatingVal = str2double(overheatingField.getText());
        overheatingField.setText(overheatingField.getText());
        
        counterLimit = (userDefinedOverheatingVal * 60 * 60)/(timerPeriod * 10);
        userDefinedConcreteVal = str2double(concreteField.getText());
        concreteField.setText(concreteField.getText());
        
        userDefinedglobalRadiationVal = str2double(globalRadField.getText());
        globalRadField.setText(globalRadField.getText());
        
        consoleArea.append(['Updated OverHeating Value : ' char(overheatingField.getText()) ' Hours/days' sprintf('\t\t')]);
        consoleArea.append(['Updated Concrete Value : ' char(concreteField.getText()) ' °C' sprintf('\t\t')]);
        consoleArea.append(['Updated Counter Limit : ' char(num2str(counterLimit)) sprintf('\n') sprintf('\n')]);
        consoleArea.append(['Updated Global Radiation Limit : ' char(globalRadField.getText()) sprintf('\n') sprintf('\n')]);
        drawnow;
    end

    function timerCallback(hObject, callbackdata)
        
        %   counter increment to indicate value collected
        counter = round(counter + 1);
        
        %   Read all active items in group
        refresh(grp);
        rGroup = read(grp);
        
        %   save values in array to be calculated for the average
        roomTempArry(counter) = rGroup(1).Value;
        co2Arry(counter) = rGroup(2).Value;
        humidityArry(counter) = rGroup(3).Value;
        wallTempArry(counter) = rGroup(4).Value;
        glassTempArry(counter) = rGroup(5).Value;
        concreteTempArry(counter) = rGroup(6).Value;
        luxArry(counter) = rGroup(7).Value;
        heatingArry(counter) = rGroup(8).Value;
        lightArry(counter) = rGroup(9).Value;
        equipArry(counter) = rGroup(10).Value - rGroup(9).Value;
        peopleArry(counter) = rGroup(11).Value + rGroup(12).Value + rGroup(13).Value + rGroup(14).Value + rGroup(15).Value + rGroup(16).Value + rGroup(17).Value + rGroup(18).Value;
        
        roofTempArry(counter) = rGroup(19).Value;
        windSpeedArry(counter) = rGroup(20).Value;
        windDirArry(counter) = rGroup(21).Value;
        sunIIIsouthArry(counter) = rGroup(22).Value;
        
        refTempArry(counter) = rGroup(23).Value;
        refConcTempArry(counter) = rGroup(24).Value;
        refCo2Arry(counter) = rGroup(25).Value;
        refHumidityArry(counter) = rGroup(26).Value;
        
        cavTempBottomArry = rGroup(27).Value;
        cavTempCenterArry = rGroup(28).Value;
        cavTempTopArry = rGroup(29).Value;
        
        outdoorTempArry = rGroup(30).Value;
        outdoorSolarRadDiffArry = rGroup(31).Value;
        outdoorSolarRadGloArry = rGroup(32).Value;
        outdoorWindSpeedArry = rGroup(33).Value;
        outdoorWindDirArry = rGroup(34).Value;
        
        %   log data the average after every 10 data collection which is every 5 minutes
        if counter == 10
            counter = 0;
            
            dbLogger();
        end
        
    end

%   About the developer and authorization
    function aboutPanel(hObject, callbackdata)
        aboutText = [ sprintf('\n') '    OPC Client Application © 2016' sprintf('\n') sprintf('\n') '      Developed by Nana Baah' sprintf('\n') sprintf('\n')];
        javax.swing.JOptionPane.showMessageDialog(frame, aboutText, 'About',javax.swing.JOptionPane.PLAIN_MESSAGE);
    end

%   exit confirmation
    function exitApp(hObject, callbackdata)
        feedback = javax.swing.JOptionPane.showConfirmDialog(frame, 'Do you really want to exit this application ?', 'Exit Confirmation', javax.swing.JOptionPane.OK_OPTION | javax.swing.JOptionPane.WARNING_MESSAGE);
        
        if feedback == javax.swing.JOptionPane.OK_OPTION
            
            if isa(da, 'double')
                close all hidden;
            else
                disconnectOPC();
                close all hidden;
            end
            
            clear dbtimer
            clear da grp
            
            opcreset;                                                       % Deletes all objects (precaution)
            consoleArea.append([char(opcfind), 10]);
            
            frame.dispatchEvent(java.awt.event.WindowEvent(frame, java.awt.event.WindowEvent.WINDOW_CLOSING));
            
            frame.dispose();
            java.lang.System.gc();
        end
    end

%   Export to Excel
    function createExcel(hObject, callbackdata)
        
        consoleArea.append([sprintf('\n'), '**************************************************************************', sprintf('\n')]);
        dbRoom = readtable('dbRoomFile.txt', 'Delimiter','\t');
        %         summary(dbRoom);´
        writetable(dbRoom,'dbRoomFile.xlsx');
        consoleArea.append(['Room Data has been successfully exported to Excel', sprintf('\n')]);
        java.lang.System.gc();
		
        dbRoof = readtable('dbRoofFile.txt', 'Delimiter','\t');
        writetable(dbRoof,'dbRoofFile.xlsx');
        consoleArea.append(['Roof Data has been successfully exported to Excel', sprintf('\n')]);
        java.lang.System.gc();
		
        dbRef = readtable('dbRefFile.txt', 'Delimiter','\t');
        writetable(dbRef,'dbRefFile.xlsx');
        consoleArea.append(['Reference Room Data has been successfully exported to Excel', sprintf('\n')]);
        java.lang.System.gc();
		
        dbOut = readtable('dbOutFile.txt', 'Delimiter','\t');
        writetable(dbOut,'dbOutFile.xlsx');
        consoleArea.append(['Outdoor Data has been successfully exported to Excel', sprintf('\n')]);
        java.lang.System.gc();
		
        dbEnergy = readtable('dbEnergyFile.txt', 'Delimiter','\t');
        writetable(dbEnergy,'dbEnergyFile.xlsx');
        consoleArea.append(['Room Energetic Data has been successfully exported to Excel', sprintf('\n')]);
        java.lang.System.gc();
		
        dbCav = readtable('dbCavFile.txt', 'Delimiter','\t');
        writetable(dbCav,'dbCavFile.xlsx');
        consoleArea.append(['Cavity Data has been successfully export to Excel', sprintf('\n')]);
        consoleArea.append(['**************************************************************************', sprintf('\n')]);
		
		java.lang.System.gc();
        drawnow;
    end

%   Menu Bar
mBar = JMenuBar();
fileMenu = javax.swing.JMenu('File');
connectItem = javax.swing.JMenuItem('Connect');
disconnectItem = javax.swing.JMenuItem('Disconnect');
exportItem = javax.swing.JMenuItem('Export Data...');
exitItem = javax.swing.JMenuItem('Exit');

fileMenu.add(connectItem);
fileMenu.add(disconnectItem);
fileMenu.add(exportItem);
fileMenu.addSeparator();
fileMenu.add(exitItem);

helpMenu = javax.swing.JMenu('Help');
manualItem = javax.swing.JMenuItem('Documentation');
aboutItem = javax.swing.JMenuItem('About OPC Client Application');

helpMenu.add(manualItem);
helpMenu.add(aboutItem);

mBar.add(fileMenu);
mBar.add(helpMenu);

frame.setJMenuBar(mBar);
frame.setVisible(true);

set(connectItem, 'MouseReleasedCallback', @connectOPC);
set(disconnectItem, 'MouseReleasedCallback', @disconnectOPC);
set(exitItem, 'MouseReleasedCallback', @exitApp);
set(aboutItem, 'MouseReleasedCallback', @aboutPanel);
set(exportItem, 'MouseReleasedCallback', @createExcel);
%   End of menu bar

dataTabPane = JTabbedPane();
dataTabPane.addTab('Room Data', roomDataPanel);
dataTabPane.addTab('Room Energetic Data', energyDataPanel);
dataTabPane.addTab('Outdoor Roof Data', roofDataPanel);
dataTabPane.addTab('Reference Room Data', refDataPanel);
dataTabPane.addTab('Cavity Data', cavDataPanel);
dataTabPane.addTab('Outdoor Data', outDataPanel);

grpTabPanel = JPanel();
grpTabPanel.setLayout(BorderLayout);
grpTabPanel.add(dataTabPane);

tabPane = JTabbedPane();
tabPane.addTab('Overview', overviewTabPanel);
tabPane.addTab('Configure', configureTabPanel);
tabPane.addTab('Data', grpTabPanel);

allTabPanel.add(tabPane, BorderLayout.CENTER);

splitPane = javax.swing.JSplitPane(javax.swing.JSplitPane.VERTICAL_SPLIT);
splitPane.setLeftComponent(allTabPanel);
splitPane.setRightComponent(JScrollPane(consoleArea));

frame.setLayout(BorderLayout);
frame.add(connectPanel, BorderLayout.NORTH);
frame.add(splitPane, BorderLayout.CENTER);

frame.setMinimumSize(Dimension(800, 700));
frame.setPreferredSize(Dimension(1000, 900));
frame.pack();

%   Ensure that the controls are fully-rendered before restoring the L&F
drawnow;

frame.setDefaultCloseOperation(javax.swing.JFrame.DO_NOTHING_ON_CLOSE);
frame.setVisible(true);

splitPane.setDividerLocation(0.9);

if isdeployed
    waitfor(fig);
end

end
