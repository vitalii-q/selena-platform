# Локальный Kubernetes-кластер Selena

Проверенная среда: MacBook Pro M1 Pro, macOS 12.7.6 (ARM64), Docker Engine 23.0.5, Minikube 1.35.0. Профиль: `selena-local`, Docker driver, Kubernetes v1.32.0. Эта инструкция не требует обновления macOS или установки дополнительных инструментов.

## Запуск и проверка

Убедитесь, что Docker Engine запущен, затем выполните:

```sh
minikube start -p selena-local --driver=docker --kubernetes-version=v1.32.0
kubectl config use-context selena-local
kubectl config current-context
minikube status -p selena-local
kubectl --context=selena-local get nodes -o wide
kubectl --context=selena-local create namespace selena-dev --dry-run=client -o yaml | kubectl --context=selena-local apply -f -
kubectl --context=selena-local get namespace selena-dev
```

Ожидаемый результат проверки: context `selena-local`, узел в состоянии `Ready`, Kubernetes v1.32.0, архитектура узла `arm64`, namespace `selena-dev` в состоянии `Active`.

## Остановка и повторный запуск

Остановка сохраняет профиль и его данные:

```sh
minikube stop -p selena-local
```

Повторный запуск:

```sh
minikube start -p selena-local --driver=docker --kubernetes-version=v1.32.0
kubectl config use-context selena-local
minikube status -p selena-local
kubectl --context=selena-local get nodes
kubectl --context=selena-local get namespace selena-dev
```

Не используйте `minikube delete` или Docker cleanup-команды для обычной остановки: они могут удалить профиль или его данные. Kubernetes Users подключается к уже существующему Docker-контейнеру `users-db` на `host.minikube.internal:9265` и отдельной логической БД `users_k8s`; второй PostgreSQL server не создаётся. Для локальной остановки кластера используйте `minikube stop -p selena-local`.
