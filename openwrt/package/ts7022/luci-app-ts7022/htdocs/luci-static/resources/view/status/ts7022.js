'use strict';
'require view';
'require fs';
'require poll';

/*
 * Датчики температуры драйвера rtl8192fe живут в MIB каждого радио:
 * wlan0 (2.4 ГГц, встроенное RTL8197F) - только два датчика PA,
 * wlan1 (5 ГГц, RTL8812FE) - датчики PA и температура кристалла SoC
 * (cputemperature). /proc/wlanN/thermal всегда 0 и не используется.
 *
 * Значения обновляются раз в 5 секунд; страница ничего не пишет.
 */

const MIB_24 = '/proc/wlan0/mib_rf';
const MIB_5  = '/proc/wlan1/mib_rf';

function parseMib(text) {
	const res = {};

	if (typeof text !== 'string')
		return res;

	text.split('\n').forEach(function(line) {
		const m = line.match(/^\s*(?:current thermal path ([AB])|cputemperature)\s*:\s*(-?\d+)\s*$/);

		if (!m)
			return;

		if (m[1])
			res['pa' + m[1]] = parseInt(m[2], 10);
		else
			res.soc = parseInt(m[2], 10);
	});

	return res;
}

function readSensors() {
	return Promise.all([
		L.resolveDefault(fs.read(MIB_24), null),
		L.resolveDefault(fs.read(MIB_5), null)
	]).then(function(res) {
		const mib24 = parseMib(res[0]);
		const mib5  = parseMib(res[1]);

		return {
			soc:   (mib5.soc != null) ? mib5.soc : null,
			pa24a: (mib24.paA != null) ? mib24.paA : null,
			pa24b: (mib24.paB != null) ? mib24.paB : null,
			pa5a:  (mib5.paA != null) ? mib5.paA : null,
			pa5b:  (mib5.paB != null) ? mib5.paB : null
		};
	});
}

function tempText(value) {
	return (value == null) ? _('n/a') : '%d °C'.format(value);
}

function tempStyle(value) {
	if (value == null)
		return 'color:#888';

	if (value >= 85)
		return 'color:#c00;font-weight:bold';

	if (value >= 75)
		return 'color:#e80;font-weight:bold';

	return '';
}

function sensorRow(key, title, value) {
	const cell = E('div', {
		'class': 'td',
		'data-title': _('Temperature'),
		'id': 'ts7022-' + key
	}, tempText(value));

	cell.style.cssText = tempStyle(value);

	return E('div', { 'class': 'tr' }, [
		E('div', { 'class': 'td', 'data-title': _('Sensor') }, title),
		cell
	]);
}

return view.extend({
	load: function() {
		return readSensors();
	},

	update: function(values) {
		Object.keys(values).forEach(function(key) {
			const cell = document.getElementById('ts7022-' + key);

			if (!cell)
				return;

			cell.textContent = tempText(values[key]);
			cell.style.cssText = tempStyle(values[key]);
		});
	},

	render: function(values) {
		const table = E('div', { 'class': 'table' }, [
			E('div', { 'class': 'tr table-titles' }, [
				E('div', { 'class': 'th' }, _('Sensor')),
				E('div', { 'class': 'th' }, _('Temperature'))
			]),
			sensorRow('soc',   _('SoC (RTL8197F)'),  values.soc),
			sensorRow('pa24a', _('2.4 GHz PA, path A'), values.pa24a),
			sensorRow('pa24b', _('2.4 GHz PA, path B'), values.pa24b),
			sensorRow('pa5a',  _('5 GHz PA, path A'), values.pa5a),
			sensorRow('pa5b',  _('5 GHz PA, path B'), values.pa5b)
		]);

		poll.add(L.bind(function() {
			return readSensors().then(L.bind(this.update, this));
		}, this), 5);

		return E('div', {}, [
			E('h2', _('Thermals')),
			E('div', { 'class': 'cbi-map' }, [
				table,
				E('p', { 'class': 'cbi-value-description' },
					_('Values are read from the Wi-Fi driver thermal sensors in /proc/wlanN/mib_rf and refresh every 5 seconds. The SoC sensor is only exposed by the 5 GHz radio.'))
			])
		]);
	}
});
