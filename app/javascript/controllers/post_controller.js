import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post"
export default class extends Controller {
  	static targets = ['post'];

	show(event) {
		event.preventDefault();
		const postId = this.data.get('id');
		const modalFrame = document.querySelector('turbo-frame#post');
		modalFrame.setAttribute('src', `/posts/show/${postId}`);
	}

	edit(event) {
		event.preventDefault();
		const postId = this.data.get('id');
		const modalFrame = document.querySelector('turbo-frame#post');
		console.log(postId);
		modalFrame.setAttribute('src', `/posts/edit/${postId}`);
	}
}
