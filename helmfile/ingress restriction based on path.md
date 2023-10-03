apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress-master
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.org/mergeable-ingress-type: master
spec:
  rules:
    - host: my-app.my-host.com
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress-minion-public
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.org/mergeable-ingress-type: minion
spec:
  rules:
    - host: my-app.my-host.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api-server
                port:
                  number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress-minion-private
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.org/mergeable-ingress-type: minion
    # Be aware to use location-snippet instead of server-snippet
    nginx.org/location-snippets: |
      allow 192.168.111.111;
      deny all;
spec:
  rules:
    - host: my-app.my-host.com
      http:
        paths:
          - path: /admin
            pathType: Prefix
            backend:
              service:
                name: admin-server
                port:
                  number: 80










apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: default
  name: ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/actions.rule-path1: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Host is www.example.com OR anno.example.com"}}
    alb.ingress.kubernetes.io/conditions.rule-path1: >
      [{"field":"host-header","hostHeaderConfig":{"values":["anno.example.com"]}}]
    alb.ingress.kubernetes.io/actions.rule-path2: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Path is /path2 OR /anno/path2"}}
    alb.ingress.kubernetes.io/conditions.rule-path2: >
      [{"field":"path-pattern","pathPatternConfig":{"values":["/anno/path2"]}}]
    alb.ingress.kubernetes.io/actions.rule-path3: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Http header HeaderName is HeaderValue1 OR HeaderValue2"}}
    alb.ingress.kubernetes.io/conditions.rule-path3: >
      [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "HeaderName", "values":["HeaderValue1", "HeaderValue2"]}}]
    alb.ingress.kubernetes.io/actions.rule-path4: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Http request method is GET OR HEAD"}}
    alb.ingress.kubernetes.io/conditions.rule-path4: >
      [{"field":"http-request-method","httpRequestMethodConfig":{"Values":["GET", "HEAD"]}}]
    alb.ingress.kubernetes.io/actions.rule-path5: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Query string is paramA:valueA1 OR paramA:valueA2"}}
    alb.ingress.kubernetes.io/conditions.rule-path5: >
      [{"field":"query-string","queryStringConfig":{"values":[{"key":"paramA","value":"valueA1"},{"key":"paramA","value":"valueA2"}]}}]
    alb.ingress.kubernetes.io/actions.rule-path6: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"Source IP is 192.168.0.0/16 OR 172.16.0.0/16"}}
    alb.ingress.kubernetes.io/conditions.rule-path6: >
      [{"field":"source-ip","sourceIpConfig":{"values":["192.168.0.0/16", "172.16.0.0/16"]}}]
    alb.ingress.kubernetes.io/actions.rule-path7: >
      {"type":"fixed-response","fixedResponseConfig":{"contentType":"text/plain","statusCode":"200","messageBody":"multiple conditions applies"}}
    alb.ingress.kubernetes.io/conditions.rule-path7: >
      [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "HeaderName", "values":["HeaderValue"]}},{"field":"query-string","queryStringConfig":{"values":[{"key":"paramA","value":"valueA"}]}},{"field":"query-string","queryStringConfig":{"values":[{"key":"paramB","value":"valueB"}]}}]
spec:
  rules:
    - host: www.example.com
      http:
        paths:
          - path: /path1
            backend:
              serviceName: rule-path1
              servicePort: use-annotation
          - path: /path2
            backend:
              serviceName: rule-path2
              servicePort: use-annotation
          - path: /path3
            backend:
              serviceName: rule-path3
              servicePort: use-annotation
          - path: /path4
            backend:
              serviceName: rule-path4
              servicePort: use-annotation
          - path: /path5
            backend:
              serviceName: rule-path5
              servicePort: use-annotation
          - path: /path6
            backend:
              serviceName: rule-path6
              servicePort: use-annotation
          - path: /path7
            backend:
              serviceName: rule-path7
              servicePort: use-annotation