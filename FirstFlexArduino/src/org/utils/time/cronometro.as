package utils.time{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Dana Card Março 2009
	 * http://www.as3.ingogoland.com/
	 * Para implementar iniciar a classe e indicar o campo de texto a alterar
	 * var meu_cronometro: cronometro = new cronometro(cronometro_tx);
	 * 
	 */
	public class cronometro {
		public var campo_texto:TextField;
		private var meu_timer:Timer;
		private var tempo_inicial:Date;
		private var tempo_inicio_pausa:Date;
		private var tempo_pausa:int;
		private var delay_:int=1000;
		public var tempo_mili:Number=0;
		
		public function cronometro(texto:TextField):void {
			campo_texto=texto;
			//iniciar_timer();
			meu_timer=new Timer(delay_);
			
		}
		public function iniciar_timer():void {
			trace("iniciar");
			campo_texto.text="00:00:00 h";
			tempo_inicial = new Date();
			tempo_pausa=0;
			meu_timer.addEventListener(TimerEvent.TIMER, actualizar);			
			meu_timer.start();
		}
		public function parar_timer():void {
			meu_timer.removeEventListener(TimerEvent.TIMER, actualizar);
			meu_timer.stop();
		}
		public function pausar_timer():void {
			parar_timer();
			tempo_inicio_pausa = new Date();
		}
		public function recomecar_timer():void {
			var tempo_actual:Date = new Date();
			tempo_pausa += (tempo_actual.getTime() - tempo_inicio_pausa.getTime()) / 1000;
			var delay_:int=100;
			meu_timer=new Timer(delay_);
			meu_timer.addEventListener(TimerEvent.TIMER, actualizar);
			meu_timer.start();
		}
		public function get totalSeconds():Number{
			return tempo_mili/1000;
		}
		private function actualizar(e:TimerEvent):void {
			var tempo_actual:Date = new Date();
			var tempo_decorrido:int = (tempo_actual.getTime() - tempo_inicial.getTime()) / 1000;
			tempo_decorrido-=tempo_pausa;
			tempo_mili= tempo_decorrido*1000;
			var horas:int=tempo_decorrido/3600;
			var minutos:int=(tempo_decorrido/60)%60;
			var segundos:int=tempo_decorrido%60;
			var sec:String=String(segundos);
			var min:String=String(minutos);
			var hor:String=String(horas);
			
			if (segundos<=9) {
				sec="0"+sec;
			}
			if (minutos<=9) {
				min="0"+min;
			}
			if (horas<=9) {
				hor="0"+hor;
			}
			campo_texto.text=hor + ":" + min + ":" + sec + " h";
			//trace("actualizar: " + campo_texto.text);
		}
	}
}