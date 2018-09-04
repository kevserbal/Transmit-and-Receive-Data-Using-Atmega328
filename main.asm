;--------------------------------------
;transmit/receive data using USART0
          ldi r16,0b11110000
		  out ddrc,r16

          ldi r18,0b11111111
		  out ddrb,r18

		  rcall usart_init
		  
loop :                          //loop is intended to receive data continuously or to wait for data to be retrieved. 
        //ldi r17,5             //Load the number which is to send
		//rcall serial_t_r17    //Uncomment this line and previous line to send data which is in r17
		  rcall serial_r        
		  out portb,r17         //The recieved data is shown in Portb
		  rjmp loop 

serial_t_r17 :
          push r16

serial_t1  :
          lds r16,ucsr0a    //wait for empty transmit buffer
		  sbrs r16,udre0    //skip if edre0 is set 
		  rjmp serial_t1

		  sts udr0,r17      //store data in transmit buffer

		  pop r16
		  ret

;---------------------------------------------------------------
;read serial port value in r17
  
serial_r :
         lds  r17,ucsr0a
		 andi r17,0x80
         breq serial_r

		 lds r17,udr0    ;read usart buffer
		 ret
;4800 bound,no parity, 8 bit per byte
  
usart_init:
       push r16
	   ldi  r16,0x00

       sts  ubrr0h,r16 ;double clock speed is off
	                   ;ubrr =6 for bound rate of 9600
	   ldi r16,12
	   sts ubrr0l,r16  ;
	   
	   ldi r16,(1<<txen0)|(1<<rxen0)  // transmit/receive enable
	   sts ucsr0b,r16

	   ldi r16,(1<<usbs0)|(3<<ucsz00) // 8 data, 2 stop
	   sts ucsr0c,r16
	   
	   pop r16
	   ret

 