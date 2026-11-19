SONAR_HOST_URL ?= http://sonarqube:9000
SONAR_NETWORK ?= sonar-net
SONAR_TOKEN ?=

.PHONY: test clean coverage linting

test:
	cd backend && ./mvnw test

clean:
	cd backend && ./mvnw clean

coverage:
	cd backend && ./mvnw verify
	cd backend && ./mvnw dependency:copy-dependencies -DoutputDirectory=target/dependency

linting: coverage
	docker run --rm \
		-e SONAR_HOST_URL="$(SONAR_HOST_URL)" \
		-e SONAR_TOKEN="$(SONAR_TOKEN)" \
		--network $(SONAR_NETWORK) \
		-v "$(CURDIR):/usr/src" \
		-u $$(id -u):$$(id -g) \
		sonarsource/sonar-scanner-cli
