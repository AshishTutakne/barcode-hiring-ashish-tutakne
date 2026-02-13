
FROM postgres:17.6-bookworm
# Fix for Docker Desktop hash sum mismatch issue
# See: https://github.com/docker/for-mac/issues/7025#issuecomment-1755988838
RUN echo 'Acquire::http::Pipeline-Depth 0;\nAcquire::http::No-Cache true;\nAcquire::BrokenProxy true;\n' > /etc/apt/apt.conf.d/99fixbadproxy
