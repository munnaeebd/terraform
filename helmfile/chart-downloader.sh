#!/bin/bash
helm repo add stakater "https://stakater.github.io/stakater-charts"
echo "Charts are downloading..."
helm pull stakater/reloader --destination ./charts/reloader --version v1.0.15
echo "Charts download complete!"