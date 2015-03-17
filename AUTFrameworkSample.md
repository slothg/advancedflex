Actionscript Unit Test Framework Sample

```
//TestCaseSample1.as
package {
	import advancedflex.debugger.aut.framework.TestCase;
	import advancedflex.debugger.aut.framework.ns.*;

	public class TestCaseSample1 extends TestCase {
		//test only.
		test function a():void {
			console.print("aa");
		}
		//test and check time if it is timeout.
		time function b():int {
			console.print("bb");
			//if used time > return value,it will throw error.
			return 10;
		}
	}
}
//TestCaseSample2.as
package {
	import advancedflex.debugger.aut.framework.TestCase;
	import advancedflex.debugger.aut.framework.ns.*;

	public class TestCaseSample2 extends TestCase {
		//test only.
		test function cc():void {
			console.print("aaa");
		}
		//test and check time if it is timeout.
		time function dd():int {
			console.print("bbb");
			return 10;
		}
	}
}
//Main.as
package {
	import advancedflex.debugger.aut.framework.TraceConsole;
	import advancedflex.debugger.aut.framework.TestSuite;
	
	public class Main {
		public function TestTests() {
			new TestSuite()
			.addTest(new TestCaseSample1())
			.addTest(new TestCaseSample2())
			.startTest(new TraceConsole());
			
		}
		/*You can also use like this.
		public function TestTests() {
			new TestCaseSample1().startTest(new TraceConsole());
			new TestCaseSample2().startTest(new TraceConsole());
			
		}*/
	}
}
```