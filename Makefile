configure:
	mirobo --ip=192.168.4.1 --token $(TOKEN) configure-wifi $(SSID) $(PASSWORD)

discover: .env
	docker-compose run --rm python-miio miplug discover

status: .env
	docker-compose run --rm python-miio sh -c 'miplug --ip $${IP} --token $${TOKEN} status'

on: .env
	docker-compose run --rm python-miio sh -c 'miplug --ip $${IP} --token $${TOKEN} on'

off: .env
	docker-compose run --rm python-miio sh -c 'miplug --ip $${IP} --token $${TOKEN} off'

pip: venv

venv:
	python3 -m venv --copies venv
	sed -i '43s/.*/VIRTUAL_ENV="$$(cd "$$(dirname "$$(dirname "$${BASH_SOURCE[0]}" )")" \&\& pwd)"/' venv/bin/activate
	sed -i '1s/.*/#!\/usr\/bin\/env python/' venv/bin/pip*
	sh -c 'source venv/bin/activate && pip install -r requirements.txt'
	sed -i '1s/.*python$$/#!\/usr\/bin\/env python/' venv/bin/*

shell: .env
	docker-compose run --rm python-miio sh

.env: envvars.yml
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
