use std::io::{self, Write};
use std::net::TcpStream;

use rand::rngs::OsRng;
use x25519_dalek::{EphemeralSecret, PublicKey};

fn main() -> io::Result<()> {
    // First step of the TLS 1.3 handshake process - generate client ephemeral secret

    let alice_secret = EphemeralSecret::random_from_rng(OsRng);
    let alice_public = PublicKey::from(&alice_secret);
    let public_key_hex: String = alice_public
        .to_bytes()
        .iter()
        .map(|byte| format!("{:02x}", byte))
        .collect();

    println!("Public key: {}", public_key_hex);

    let address = "localhost:3000"; // try out by running 'python -m http.server 3000' on terminal
                                    // to receive the following data

    // Just for demonstration purposes, we send GET request with above public key over raw TCP
    // connection
    // TODO start implementing TLS 1.3 handshake protocol instead

    match TcpStream::connect(address) {
        Ok(mut stream) => {
            println!("Successfully connected to server in localhost");

            let key_param = format!("key={public_key_hex}");
            let request = format!(
                "GET /?{} HTTP/1.1\r\nHost: example.com\r\nConnection: close\r\n\r\n",
                key_param
            );

            // Send the constructed request to the server
            stream.write_all(request.as_bytes())?;

            // This is just to demonstrate sending data over the TCP connection to localhost

            println!("The request has been sent...");

            // Additional code to read the response would go here.
        }
        Err(e) => {
            println!("Failed to connect: {}", e);
        }
    }
    Ok(())
}
