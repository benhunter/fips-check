use openssl::ssl::{SslConnector, SslMethod};
use std::net::ToSocketAddrs;

fn main()  {
    let server: &str = "google.com";
    let port = 443;

    let addr = format!("{}:{}", server, port)
        .to_socket_addrs()
        .unwrap()
        .next()
        .ok_or("Invalid address")
        .unwrap();
    println!("{}", addr);

    println!("Checking TLS protocols and cipher suites...");
    let connector = SslConnector::builder(SslMethod::tls()).expect("Could not build SslConnector").build();

    println!("Connecting TcpStream...");
    let stream = std::net::TcpStream::connect(addr).unwrap();
    println!("TcpStream: {:?}", stream);

    println!("Connecting to SSL stream...");
    let ssl_stream = connector.connect(server, stream);

    match ssl_stream {
        Ok(ssl_stream) => {
            let negotiated_protocol = ssl_stream.ssl().version_str();
            println!("Negotiated TLS Protocol: {}", negotiated_protocol);

            let cipher = ssl_stream.ssl().current_cipher().ok_or("No cipher info available");
            println!("Cipher: {}", cipher.expect("Could not unwrap cipher").name());
        }
        Err(e) => {
            println!("Failed to establish SSL connection: {}", e);
        }
    }
}
