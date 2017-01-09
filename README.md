OPC DA client application software
==================================

Introduction
------------
The purpose of this project is to develop and implement the OPC DA client application software by integrating the technologies and systems which was researched in Part 1. 

Source code
-----------
The core functionalities of the client application are solely programmed in **MATLAB** while
the graphical user interface was developed in **Java (i.e. Swing)**.

Functionalities
--------------- 
Based on the main and functional requirements, the OPC DA client application could seamlessly connect/disconnect to/from the provided OPC DA server. All requested data to the OPC server was successfully logged to a series of external database files for further data processing and analyses.

Each logged data depicts an average of ten (10) requested values accumulated every 30
seconds for a 5-minute time span. Based on the sensors installed in the façade (including
room), four distinct algorithms were developed to regulate and control the actuators for the
lamellas/windows. The algorithms basically identified all the possible climatic conditions in
the room (including façade) and implement an adaptive comfort model based on the DIN EN15251. 

The DIN EN15251 standard defines the criteria used for ”indoor environmental
input parameters for design and assessment of energy performance of buildings addressing
indoor air quality, thermal environment, lighting and acoustics”. 

The user requirements on the other hand, entails the Graphical User Interface (GUI), which is completely developed in Java (Swing API). Albeit the data read from the OPC server is directly logged to the external database files, these data are also displayed and categorized in a tabulated form on the user interface. Data handling and conversion between MATLAB and Java (Swing) is managed
due to the constant request of real-time data from the KNX system and the option for
users to regularly input data in the application. The application is compiled into a stand-alone
executable file for commercial use. The executable OPC client application is installed and implemented during the testing phase. A test script is created that periodically writes sequence
of values to the OPC server, which acts as the sensors’ values, to determine the reaction
of the lamellas/windows during the testing phase. The memory management performance
of the client application is consistently analyzed to reduce memory leaks and consumption
from the continuous size increment of the databases.