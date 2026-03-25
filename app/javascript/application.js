import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll(".star");
  const input = document.getElementById("rating-input");

  if (!stars.length || !input) return;

  stars.forEach((star, index) => {
    star.onclick = () => {
      input.value = index + 1;
      stars.forEach((s, i) => {
        s.classList.toggle("active", i < index + 1);
        s.textContent = i < index + 1 ? "★" : "☆";
      });
    };

    star.onmouseover = () => {
      stars.forEach((s, i) => {
        s.textContent = i <= index ? "★" : "☆";
      });
    };

    star.onmouseleave = () => {
      const val = parseInt(input.value) || 0;
      stars.forEach((s, i) => {
        s.textContent = i < val ? "★" : "☆";
      });
    };
  });
});