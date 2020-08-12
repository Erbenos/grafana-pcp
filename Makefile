#
# build grafana-pcp
#
YARN = yarn
JSONNET = jsonnet
JSONNETBUNDLER = jb

DASHBOARD_DIR := src/dashboards
DASHBOARDS := $(addprefix $(DASHBOARD_DIR)/,pcp-vector-host-overview.json pcp-vector-container-overview-cgroups1.json pcp-vector-container-overview-cgroups2.json pcp-vector-bcc-overview.json pcp-bpftrace-system-analysis.json pcp-bpftrace-flame-graphs.json fulltext-graph-preview.json fulltext-table-preview.json checklist-overview.json checklist-cpu-overview.json checklist-cpu-sys-overview.json checklist-cpu-user-overview.json checklist-storage-overview.json)

default: build

node_modules: package.json
	$(YARN) install
	sed -i 's@results.push(createIgnoreResult(filePath, cwd));@// &@' node_modules/eslint/lib/cli-engine/cli-engine.js

vendor: jsonnetfile.json
	$(JSONNETBUNDLER) install

$(DASHBOARD_DIR)/%.json: $(DASHBOARD_DIR)/%.jsonnet
	$(JSONNET) -J vendor -o $@ $<

dashboards: $(DASHBOARDS)

dist: node_modules vendor dashboards
	$(YARN) run build

build: dist

dev: node_modules vendor dashboards
	$(YARN) run dev

watch: node_modules vendor dashboards
	$(YARN) run watch

test: node_modules
	$(YARN) run test

clean:
	rm -rf node_modules vendor dist
