package  ropez.net{
	
	// FLASH IMPORT CLASS
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	
	// EXTERNAL IMPORT CLASS
	import com.maclema.mysql.Connection;
	import com.maclema.util.ResultsUtil;
	import com.maclema.mysql.Field;
	import com.maclema.mysql.Mysql
	import com.maclema.mysql.Statement;
	import com.maclema.mysql.MySqlToken;
	import com.maclema.mysql.events.MySqlErrorEvent;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.MySqlService;
	import com.maclema.mysql.events.MySqlEvent;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.MySqlToken;
	
	
	public dynamic class sql extends Sprite{
		
		// STATIC CONST LISTENERS
		public static const COMPLETE_CONNECTION:String="COMPLETE_CONNECTION";
		public static const ERROR_CONNECTION:String="ERROR_CONNECTION";
		public static const CANCEL_CONNECTION:String="CANCEL_CONNECTION";
		
		public static const COMPLETE_QUERY:String="COMPLETE_QUERY";
		public static const ERROR_QUERY:String="ERROR_QUERY";
		
		// GET INFO
		public static const GET_ROWS:String="rows";
		public static const GET_COLUMN:String="column";
		public static const GET_BODYS:String="bodys";
		public static const GET_INFO:String="info";
		
		// FORMAT INFO
		public static const INFO_STRING:String="string";
		public static const INFO_ARRAY:String="array";
		public static const INFO_OBJECT:String="object";
		public static const INFO_JSON:String="json";
		public static const INFO_VECTOR:String="vector";
		public static const INFO_FIELD:String="field";
		
		
		// EXTERNAL INSTANCES...................................
		private var c:Connection;
		
		
		// PRIVATE VARS ROPEZ
		private var host:String;
		private var port:int;
		private var user:String;
		private var pw:String;
		private var db:String;
		
		// PRIVATE VARS UTILS
		private var e:*;
		private var end:int=0;
		
		
		private var rs:ResultSet;
		
		

		public function sql(host:String="",port:int=0,user:String="",pw:String="",db:String="") {
			
		
			connection(host,port,user,pw,db);
			
			
		}
		
		public function connection(host:String="",port:int=3306,user:String="",pw:String="",db:String=""):void{
			
			// GLOBAL VALUES CONNECTION.
			this.host=host;
			this.port=port;
			this.user=user;
			this.pw=pw;
			this.db=db;
			
			
			// VALDATE FIELDS CONNECTION
			if(
				this.host.length < 1 || this.host == null ||
				this.port < 1 || this.port == -1 ||
			    this.user.length < 1 || this.user == null ||
			    this.pw.length < 1 || this.pw == null ||
			    this.db.length < 1 || this.db == null 
			){
				dispatchEvent( new Event(ERROR_CONNECTION));
				return;
			}
		
			// CONNECT 
		c= new Connection(this.host,this.port,this.user,this.pw,this.db);
		c.addEventListener(Event.CONNECT,_CONNECTION);
		c.connect();
			
		}
		
		
		// COMPLETE CONNECTION
		private var _value_connection:Boolean;
		private var token:MySqlToken;
		private var st:Statement;
		//private var result:ResultSet;
		private function _CONNECTION(event:Event):void{
			
			_value_connection=true;
			dispatchEvent( new Event(COMPLETE_CONNECTION));
		}
		
		public function get value_connection():Boolean{
			return _value_connection;
		}
		
		
		private var _result:*;
		private var info:String="array";
		private var get:Object;
	
		
		public function query(v:String,sync:Boolean=false):Array{
			end=0;
			// ADD NEW TOKEN
			token= new MySqlToken();
			st = c.createStatement();
			st.streamResults=true;
			
			token = st.executeQuery(v);
	        token.addEventListener(MySqlEvent.ROWDATA,ROW_DATA);
	        token.addEventListener(MySqlEvent.COLUMNDATA,COLUMN_DATA);
			this.addEventListener(Event.ENTER_FRAME,END_REQUEST);
			
			return new Array();
		}
		
		private function END_REQUEST(event:Event):void{
			
			if(end > 0){
			dispatchEvent( new Event(COMPLETE_QUERY));
			token.removeEventListener(MySqlEvent.ROWDATA,ROW_DATA);
	        token.removeEventListener(MySqlEvent.COLUMNDATA,COLUMN_DATA);
			this.removeEventListener(Event.ENTER_FRAME,END_REQUEST);
			}
			
			end++;
		}
		
		private function END_RESULT(e:MySqlEvent):void {
			trace("Progress");
			this.e=e;
			
		}
		
		private function ROW_DATA(e:MySqlEvent):void {
			this.e=e;
			dispatchEvent( new Event(COMPLETE_QUERY));
		}
		
		private function COLUMN_DATA(e:MySqlEvent):void {
			//this.e=e;
			//dispatchEvent( new Event(COMPLETE_QUERY));
		}
		
		
		
		
			public function rows(value:*=null):Array{
				
			var v:Array=[];
			var o:*;
			c = st.getConnection();
			rs = this.e.resultSet;
			var row:Array=[];
			
			if(value is Array && value != null && value != undefined && value.length > 0){
			while(rs.next()){
				row=[];
				for(var u:int=0 ; u < value.length ; u++){
				row.push(rs.getString(value[u]));
				}
				v.push(row);
			}
			return v;
			}
			
			
				
		
		return v;
		}
		
		
		
		

	}
	
}
