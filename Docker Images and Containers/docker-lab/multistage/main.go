package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "time"
)

func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        hostname, _ := os.Hostname()
        fmt.Fprintf(w, `
<!DOCTYPE html>
<html>
<head><title>Multi-Stage Docker Build</title></head>
<body>
    <h1>Multi-Stage Build Example</h1>
    <p>Hostname: %s</p>
    <p>Time: %s</p>
    <p>This is a Go application built using multi-stage Docker build!</p>
</body>
</html>`, hostname, time.Now().Format(time.RFC3339))
    })

    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        fmt.Fprintf(w, `{"status":"healthy","timestamp":"%s"}`, time.Now().Format(time.RFC3339))
    })

    log.Printf("Server starting on port %s", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}
