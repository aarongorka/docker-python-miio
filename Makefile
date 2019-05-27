configure:
	mirobo --ip=192.168.4.1 --token $(TOKEN) configure-wifi $(SSID) $(PASSWORD)

discover: venv
	miplug discover

status:
	miplug --ip $(IP) --token $(TOKEN) status

pip: venv

venv:
	python3 -m venv --copies venv
	sed -i '43s/.*/VIRTUAL_ENV="$$(cd "$$(dirname "$$(dirname "$${BASH_SOURCE[0]}" )")" \&\& pwd)"/' venv/bin/activate
	sed -i '1s/.*/#!\/usr\/bin\/env python/' venv/bin/pip*
	sh -c 'source venv/bin/activate && pip install -r requirements.txt'
	sed -i '1s/.*python$$/#!\/usr\/bin\/env python/' venv/bin/*

node_modules: package.json package-lock.json
	docker-compose run --rm node npm i --no-bin-links

shell: node_modules
	docker-compose run --rm node sh

