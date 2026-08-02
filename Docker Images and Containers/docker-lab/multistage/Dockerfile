# Build stage
FROM golang:1.19-alpine AS builder

WORKDIR /app
COPY main.go .

# Build the application
RUN go build -o webapp main.go

# Runtime stage
FROM alpine:latest

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/webapp .

# Expose port
EXPOSE 8080

# Run the application
CMD ["./webapp"]
