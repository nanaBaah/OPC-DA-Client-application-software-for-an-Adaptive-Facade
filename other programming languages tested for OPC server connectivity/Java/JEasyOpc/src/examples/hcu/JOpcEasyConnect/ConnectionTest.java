package hcu.JOpcEasyConnect;

import javafish.clients.opc.JOpc;
import javafish.clients.opc.component.OpcGroup;
import javafish.clients.opc.component.OpcItem;
import javafish.clients.opc.exception.ComponentNotFoundException;
import javafish.clients.opc.exception.ConnectivityException;
import javafish.clients.opc.exception.SynchReadException;
import javafish.clients.opc.exception.UnableAddGroupException;
import javafish.clients.opc.exception.UnableAddItemException;
import javafish.clients.opc.variant.Variant;

public class ConnectionTest {
	public static void main(String[] args) {
		ConnectionTest test = new ConnectionTest();

		JOpc.coInitialize();

		JOpc jopc = new JOpc("localhost", "WMaEIBOPCServer", "JOPC1");

		OpcItem item1 = new OpcItem("CommonData.WeatherData_Research.0/3/21", true, "");
		OpcGroup group = new OpcGroup("group1", true, 500, 0.0f);

		group.addItem(item1);
		jopc.addGroup(group);

		try {
			jopc.connect();
			System.out.println("JOPC client is connected...");
		} catch (ConnectivityException e2) {
			e2.printStackTrace();
		}
		try {
			jopc.registerGroups();
			System.out.println("OPCGroup are registered...");
		} catch (UnableAddGroupException e2) {
			e2.printStackTrace();
		} catch (UnableAddItemException e2) {
			e2.printStackTrace();
		}

		synchronized (test) {
			try {
				test.wait(50);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		// Synchronous reading of item
		int cycles = 7;
		int acycle = 0;
		while (acycle++ < cycles) {
			synchronized (test) {
				try {
					test.wait(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}

			try {
				OpcItem responseItem = jopc.synchReadItem(group, item1);
				System.out.println(responseItem);
				System.out.println(Variant.getVariantName(responseItem.getDataType()) + ": " + responseItem.getValue());
			} catch (ComponentNotFoundException e1) {
				e1.printStackTrace();
			} catch (SynchReadException e) {
				e.printStackTrace();
			}
		}

		JOpc.coUninitialize();
	}
}
