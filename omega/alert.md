# Omega_alert

## 1. influxdb 订阅问题

influxdb 有数据但是无法订阅，可能是由于创建了多个订阅，删除即可。

	SHOW SUBSCRIPTIONS;   显示当前订阅
	DROP SUBSCRIPTION "kapacitor-1b8d77b8-ec8f-4f27-bbff-f17d4e965bfe"  ON "shurenyun"."default";  删除一个订阅






