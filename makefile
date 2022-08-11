TARGET_DIR=dist
SOURCE_DIR=src

all:
	make clean
	./build.sh

clean:
	rm -rf $(TARGET_DIR)

watch:
	make
	# Spawn in parallel browser-sync to serve the files and fswatch to re-make
	# when files change. Kill both with one <CTRL+C>.
	(trap 'kill 0' SIGINT; browser-sync --no-ui --no-notify --server --watch $(TARGET_DIR) $(TARGET_DIR) & fswatch --latency 0.1 --one-per-batch -0 $(SOURCE_DIR) *.sh | xargs -0 -n1 -I{} make)
