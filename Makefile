# Makefile for building the towers project
# Makefile describes how to compile and link the project to github page & firebase hosting
# Deploy Flutter web app to GitHub Pages & firebase hosting

BASEHREF = '/flutter-website/'
GITHUB_REPO = git@github.com:Cybertron-Ant/flutter-website.git
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

deploy-web:
	@echo "Clean existing repository. . ."
	flutter clean

	@echo "Getting packages. . ."
	flutter pub get

	@echo "Building for web. . ."
	flutter build web --base-href $(BASEHREF) --release

	@echo "Deploying to Git repository. . ."
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M master && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u --force origin master

	cd ../..
	@echo "🟢 Finished deploying. . ."

.PHONY: deploy-web


deploy-firebase-hosting:
	@echo "Clean existing repository. . ."
	flutter clean

	@echo "Getting packages. . ."
	flutter pub get

	@echo "Building for the Web. . ."
	flutter build web --release

	@echo "initializing Firebase. . ."
	firebase login
	firebase init

	@echo "Deploying Web app to Firebase. . ."
	firebase deploy

	@echo "🟢 Finished deploying Web app to Firebase. . ."

.PHONY: deploy-firebase-hosting