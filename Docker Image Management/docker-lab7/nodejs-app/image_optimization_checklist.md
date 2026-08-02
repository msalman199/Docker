# Docker Image Optimization Checklist

## Size Optimization
- [ ] Use .dockerignore to exclude unnecessary files
- [ ] Use multi-stage builds to separate build and runtime dependencies
- [ ] Choose appropriate base images (alpine variants when possible)
- [ ] Remove package manager cache after installations
- [ ] Combine RUN commands to reduce layers

## Security Optimization
- [ ] Use non-root users
- [ ] Keep base images updated
- [ ] Scan images for vulnerabilities
- [ ] Use specific image tags, not 'latest'
- [ ] Remove unnecessary packages and tools

## Performance Optimization
- [ ] Order Dockerfile instructions by frequency of change
- [ ] Use proper signal handling (dumb-init)
- [ ] Set appropriate resource limits
- [ ] Use health checks

## Maintenance
- [ ] Tag images with meaningful versions
- [ ] Document image contents and usage
- [ ] Regular cleanup of unused images
- [ ] Monitor image sizes over time
