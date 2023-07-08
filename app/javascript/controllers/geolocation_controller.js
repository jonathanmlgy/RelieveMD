import { Controller } from "@hotwired/stimulus"

const options = {
	enableHighAccuracy: true,
	timeout: 5000,
	maximumAge: 0
};

// Connects to data-controller="geolocation"
export default class extends Controller {
	success(pos) {
	const crd = pos.coords;
	const latitude = crd.latitude;
	const longitude = crd.longitude;

	// Send AJAX request to your Rails controller
	const url = '/posts/location';
	const data = { latitude: latitude, longitude: longitude };

	fetch(url, {
		method: 'POST',
		headers: {
		'Content-Type': 'application/json',
		'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
		},
		body: JSON.stringify(data)
	}).then(response => {
		// Handle the response if needed
	}).catch(error => {
		console.error('Error:', error);
	});

		console.log('Your current position is:');
		console.log(`Latitude : ${crd.latitude}`);
		console.log(`Longitude: ${crd.longitude}`);
		console.log(`More or less ${crd.accuracy} meters.`);
	}

	error(err) {
		console.warn(`ERROR(${err.code}): ${err.message}`);
	}

	connect () {
		navigator.geolocation.getCurrentPosition(this.success, this.error, options);
	}
}
