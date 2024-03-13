##Тест
Для теста нужно собрать докер и запустить в нём энсибл плэйбук.

##Докер:

###Сборка образа
```docker build -t debian:PerfectPanel .```

###Запуск
```docker run -it -v ~/workspace/PerfectPanel:/root/PerfectPanel debian:PerfectPanel bash```

```
cd PerfectPanel/ansible/ ;\
ansible-playbook playbook.yml
```
