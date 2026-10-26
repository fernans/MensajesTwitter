package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.ui.Mouse;
	import flash.net.Socket;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import com.greensock.TweenNano;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextFieldAutoSize;
	
	public class Display extends MovieClip {
		
		public var socket:ServerSocket=null;
		public var clientSocket:Socket=null;
		public var confirmTimer:Timer=null;
		
		public var command:String=null
		public var message:String="";
		
		public var maxChildren:Number=10;
		
		public function Display() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event=null) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			Mouse.hide();
			
			socketListen();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
		}
		
		public function socketListen() {
			socket=null;
			socket=new ServerSocket();
			socket.addEventListener(ServerSocketConnectEvent.CONNECT, socketConnect);
			socket.bind(1234);
			socket.listen();
		}
		
		public function socketEndListening() {
			if (socket!=null && socket.listening) socket.close();
		}
		
		public function socketConnect(e:ServerSocketConnectEvent):void {
			trace("CLIENT CONNECTED");
			socket.removeEventListener(ServerSocketConnectEvent.CONNECT, socketConnect);
			clientSocket = e.socket; // You can now read and write data from the socket instance
			clientSocket.addEventListener( ProgressEvent.SOCKET_DATA, dataReceived ); 
			clientSocket.addEventListener( Event.CLOSE, clientDisconnect );
			// only 1 connection
			socketEndListening();
			command=null;
			message="";
			// confirm connection
			confirmTimer=new Timer(5*1000,1);
			confirmTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rejectConnection);
			confirmTimer.start();
		}
		
		public function rejectConnection(e:Event=null) {
			if (clientSocket!=null) {
				clientSocket.close();
				clientDisconnect();
			}
		}
		
		public function clientDisconnect(e:Event=null) {
			trace("CLIENT DISCONNECTED");
			clientSocket.removeEventListener( ProgressEvent.SOCKET_DATA, dataReceived ); 
			clientSocket.removeEventListener( Event.CLOSE, clientDisconnect );
			// wait for a new connection
			socketListen();
		}
		
		public function dataReceived(e:ProgressEvent=null) {
			while(clientSocket.bytesAvailable>0) {
				var byte:int=clientSocket.readByte();
				if (byte!=13) {
					if (command==null) {
						command=String.fromCharCode(byte);
						trace("set comm: "+command);
					} else {
						var temp:String=String.fromCharCode(byte);
						message+=temp;
						trace("add msg: "+message);
					}
				} else { // 13 means, analyze message
					trace("Command: "+command);
					trace("Message: "+message);
					// check "HELLO" code
					if (confirmTimer!=null) {
						if (command!="H" || message!="1234") {
							rejectConnection(null); // reject connection
							return;
						} else { // accept connection
							confirmTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, rejectConnection);
							confirmTimer.stop();
							confirmTimer=null;
							clientSocket.writeMultiByte("Aceptada"+String.fromCharCode(13),"none");
							clientSocket.flush();
						}
					}
					// analyze
					switch (command.toLocaleUpperCase()) {
						case "M":
							// lanzar mensaje
							lanzarMensaje(message);
						break;
						case "N":
							// establecer numero maximo de hijos
							var n:Number=Number(message);
							if (!isNaN(n)) maxChildren=n;
						break;
						case "D":
							// delete older message
							eliminarMensaje();
						break;
						case "C":
							// clear all messages
							eliminarTodos();
						break;
						default:break;
					}
					// reset status
					command=null;
					message="";
				}
			}
		}
		
		// lanzar mensajes
		public function lanzarMensaje(men:String="") {
			trace("lanzarMensaje: "+men);
			if (this.numChildren>=maxChildren) eliminarMensaje();
			var tf:TextField=new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline=false;
			tf.border=true;
			tf.text=men;
			this.addChild(tf);
			tf.x=Math.random()*(stage.stageWidth-tf.textWidth);
			tf.y=Math.random()*(stage.stageHeight-tf.textHeight);
			trace("("+stage.stageWidth+","+stage.stageHeight+")"+tf.x+","+tf.y+" : "+tf.textWidth+","+tf.textHeight);
			tf.alpha=0;
			TweenNano.to(tf,1,{alpha:1});
		}
		
		public function eliminarMensaje(i:Number=0) {
			if (this.getChildAt(i)!=null)
					TweenNano.to(this.getChildAt(i),2,{alpha:0, onComplete:removeChild, onCompleteParams:[this.getChildAt(i)]});
		}
		
		public function eliminarTodos() {
			for (var i:int=0;i<this.numChildren;i++) eliminarMensaje(i);
		}
		
		// interactividad
		public function key(e:KeyboardEvent=null) {
			eliminarTodos();
		}
		
	}
	
}
