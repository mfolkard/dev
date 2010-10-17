import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.io.*;

public class fget {

	private String url = "";
	private int from = 0;
	private int to = 0;
	private int pattern_length = 0;
	public NumberFormat formatter;
	public String prefix = "";

	public static void main (String args[]){
		fget f = new fget();
		f.processArgs(args);
		f.processURL();
		String s = f.repeatString("\\*", f.pattern_length);
		try {
			for(int x = f.from; x <= f.to; x++){
				Process p = Runtime.getRuntime().exec("wget " + f.url.replaceAll(s, f.formatter.format(x)));
				//System.out.println("wget " + f.url.replaceAll(s, f.formatter.format(x)));
			}
		}
		catch (IOException e){
			System.out.println("IOException occured:");
			e.printStackTrace();
			System.exit(-1);
		}	
	}

	public void processArgs(String args[]){
		System.out.println(args.length);
		for(int x=0; x < args.length; x++){
			if(args[x].equals("-u")){
				System.out.println("The URL is:" + args[x+1]);
				this.url = args[x+1];
			} else if (args[x].equals("-f")){
				System.out.println("The from is:" + args[x+1]);
				this.from = Integer.parseInt(args[x+1]);
			} else if (args[x].equals("-t")){
				System.out.println("The to is:" + args[x+1]);
				this.to = Integer.parseInt(args[x+1]);
			} else if (args[x].equals("-p")){
				System.out.println("The prefix is:" + args[x+1]);
				this.prefix = args[x+1];
			}
		}
	}

	public void processURL(){
		int start = this.url.indexOf('*');
		int end = this.url.lastIndexOf('*');
		this.pattern_length = end - start + 1;
		System.out.println("pattern_length:" + this.pattern_length);
		String p = repeatString("0", this.pattern_length);
		this.formatter = new DecimalFormat("#" + p + ".###");
	}

	private String repeatString(String s, int n){
		if(n == 1) {
			return s;
		} else {
			return s + repeatString(s, n-1);
		}
	}

}