import java.io.File;
import java.util.*;
import java.lang.management.BufferPoolMXBean;
import java.lang.management.ManagementFactory;
import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.*;

import com.sun.tools.attach.VirtualMachine; // Attach API

/**
 * Simple tool to attach to running VM to report buffer pool usage.
 */

public class MonBuffers {
    static final String CONNECTOR_ADDRESS =
          "com.sun.management.jmxremote.localConnectorAddress";
    private static void logo() {
	System.out.println("Usage:java -cp $JAVA_HOME/lib/tools.jar:. MonBuffers <pid> [interval] [count]");
	System.exit(1);
    }

    public static void main(String args[]) throws Exception {
        // attach to target VM to get connector address
	int sleep = 1000;
	int count = 10;

	if(args.length == 0) {
	    logo();
	}
       	if (args.length > 1) {
	    try {
		sleep = Integer.parseInt(args[1]);
	    } catch(Exception e) {
		logo();
	    }
	}
	if (args.length >2) {
	    try {
		count = Integer.parseInt(args[2]);
	    } catch(Exception e) {
		logo();
	    }
	}
	System.out.println("start monitor DirectBuffer,pid:"+args[0]+",interval:"+sleep+",count:"+count);
	
        VirtualMachine vm = VirtualMachine.attach(args[0]);
        String connectorAddress = vm.getAgentProperties().getProperty(CONNECTOR_ADDRESS);
        if (connectorAddress == null) {
            // start management agent
            String agent = vm.getSystemProperties().getProperty("java.home") +
                    File.separator + "lib" + File.separator + "management-agent.jar";
            vm.loadAgent(agent);
            connectorAddress = vm.getAgentProperties().getProperty(CONNECTOR_ADDRESS);
            assert connectorAddress != null;
        }

        // connect to agent
        JMXServiceURL url = new JMXServiceURL(connectorAddress);
        JMXConnector c = JMXConnectorFactory.connect(url);
        MBeanServerConnection server = c.getMBeanServerConnection();

        // get the list of pools
        Set<ObjectName> mbeans = server.queryNames(
            new ObjectName("java.nio:type=BufferPool,*"), null);
        List<BufferPoolMXBean> pools = new ArrayList<BufferPoolMXBean>();
        for (ObjectName name: mbeans) {
            BufferPoolMXBean pool = ManagementFactory
                .newPlatformMXBeanProxy(server, name.toString(), BufferPoolMXBean.class);
            pools.add(pool);
        }

        // print headers
        for (BufferPoolMXBean pool: pools)
            System.out.format("         %8s             ", pool.getName());
        System.out.println();
        for (int i=0; i<pools.size(); i++)
            System.out.format("%6s %10s %10s  ",  "Count", "Capacity", "Memory");
        System.out.println();

        // poll and print usage
        for (int i = 0;i < count; i++) {
            for (BufferPoolMXBean pool: pools) {
                System.out.format("%6d %10d %10d  ",
                    pool.getCount(), pool.getTotalCapacity(), pool.getMemoryUsed());
            }
            System.out.println();
            Thread.sleep(sleep);
        }
    }
}
