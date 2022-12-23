# # Check whether database is down and restart if so, needed for tests and general app function
# database = "./scripts/start_database.sh"
# # Before running tests, restart the database if down
# test = "cargo cmd database && cargo nextest run --failure-output final"
# # Clean Postgres from temporary databases that are made by test runs
# clean = "./scripts/clean_database.sh newsletter"
# # Build app for production. `--target-dir` needed as otherwise the app is not being built in the `target` directory
# build = "cargo build --release --target-dir ../target"
# # Run app after restarting database
# run = "cargo cmd database && cargo run | bunyan"
# # Run productionized app after restarting database
# run-prod = "cargo cmd database && ./target/release/zero2prod | bunyan"
# # Run tests, clean temporary databases, run the app
# dev = "cargo watch -x 'cmd test' -x 'cmd clean' -x 'cmd run'"
# # Run tests, clean temporary databases, run the productionized app
# prod = "cargo watch -x 'cmd test' -x 'cmd clean' -x 'cmd build && cargo cmd run-prod'"
# # Run tests, clean temporary databases, build Docker containers
# docker-build = "cargo watch -x 'cmd test' -x 'cmd clean' -s './scripts/build.sh'"
# # Run tests, clean temporary databases, build Docker containers, run the app in Docker
# docker-dev = "cargo watch -x 'cmd test' -x 'cmd clean' -s './scripts/run.sh'"
# # Run tests, clean temporary databases, build Docker containers, run the productionized app in Docker
# docker-prod = "cargo watch -x 'cmd test' -x 'cmd clean' -s './scripts/run.sh release'"
