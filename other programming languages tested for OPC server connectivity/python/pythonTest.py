#imports the OpenOPC.py module file
import OpenOPC

#DCOM mode is used to talk directly to OPC servers without the need for the OpenOPC Gateway Service
opc = OpenOPC.client()

#Getting a list of available OPC servers
print "1"
print opc.servers()

#Connect to OPC Server
print "2"
print opc.connect('WMaEIBOPCServer')

print "3"
for x in opc.servers():
	print opc.connect(x)

#Read the specified OPC item
print "4"
print opc.read('CommonData.WeatherData_Research.0/3/20')

#Getting a list of available items
print "5"
print opc.list()

#Retrieving OPC server information
print "6"
print opc.info()


'''
Cause
The 0x800706BA DCOM error appears in an OPC Client application it is unable to connect to the OPC server, or loses an existing connection.  An OPC client may actually "believe" it has a live connection to the OPC Server, but truly does not. This can happen under several conditions including: The OPC Client application launched the OPC Server successfully, but due to lack of permissions (DCOM or otherwise), the OPC Client can't access the OPC Server for data. In this case, the OPC Server might actually be running, but not accessible to the OPC Client.

The OPC Server was initially running, but access has since been terminated. For example, the server was shutdown.

The OPC Client PC is trying to create a group, but the OPC Client PC's Firewall is on.

DCOM Error 0x800706BA is only slightly different from DCOM Error 0x80040202 in that the OPC Client is typically unable to establish ANY communication with the OPC Server (even though it successfully launched it initially). In DCOM Error 0x80040202, the OPC Client is indeed able to establish Synchronous communication with the OPC Server.

Symptoms
When an OPC Client application is unable to receive callbacks from an OPC Server, users will notice at least three symptoms:

    The OPC Client application will fail to create an OPC Group altogether.
    The OPC Client application will not be able to show data updates. Instead, data values will remain unchanged.
    The OPC Server will show as running on the OPC Server PC, but the OPC Client application will be unable to connect to the OPC Server.

Background
In DCOM Error 0x800706BA, the OPC Server suddenly becomes unavailable to the OPC Client (or simply disconnected from the OPC Client application). This can happen due to any of the following factors:

    OPC Server has shutdown without informing the OPC Client application. This shutdown could be due to a user that ends the OPC Server's Windows process (using Task Manager) or a "bug" in the OPC Server software that caused it to "crash".
    OPC Server becomes physically disconnected from the OPC Client application. For instance, someone disconnects a network cable, or a network device (such as a hub, switch, router, etc) fails.
    The OPC Client application is suddenly unable to receive callbacks from the OPC Server due to a change in its own Windows configuration. For example, someone might turn on the Windows Firewall, enables Simple File Sharing, changes the Security Limits of the DCOM Access Permissions.

OPC supports a report-by-exception (RBX) mechanism whereby the OPC Server sends data updates to the OPC Client (such as an HMI, Historian, APC, ERP, etc.) whenever the data changes (also known as "on data change"). OPC terminology refers to this mechanism as "subscription". OPC Servers are able to achieve subscription updates through the use of asynchronous callbacks. In other words, when the OPC Server detects a change in the data, it immediately "calls" the client back with the data update. This is an asynchronous mechanism because the OPC Client does not know when the OPC Server will send the data. However, if you don't set the security settings properly, these data updates will fail. OPC Client applications typically indicate this failure by setting the Quality value of an item to "Bad".

Callbacks force an OPC Server to actively establish a connection with an OPC Client. In a sense, the OPC Server becomes a Client and the Client becomes a Server.

Test
One simple test to determine whether or not a callback is failing is to force the OPC Client to issue a "Synchronous Cache Read" or a "Synchronous Device Read." If either one of these return values with "Good" quality, then the lack of data updates is likely due to the OPC Server being unable to send callbacks to the OPC Client application.

However, if you determine that the OPC Client application is indeed able to launch the OPC Server, but is unable to read values from it (even Synchronous), then it is likely that the User Account that is running the OPC Client application does not have sufficient permissions to access the OPC Server. In this case, you should inspect DCOM Access Permissions on the OPC Server PC.
'''