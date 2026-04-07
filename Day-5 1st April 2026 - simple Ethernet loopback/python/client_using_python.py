import socket

HOST = "192.168.1.10"
PORT = 7

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))

try:
    while True:
        message = input("Enter message: ")
        if message.lower() == "exit":
            break

        client.sendall(message.encode("ascii"))
        data = client.recv(1024)
        print("Received     :", data.decode("ascii"))

finally:
    client.close()
