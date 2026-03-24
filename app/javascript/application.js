// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener("turbo:load", () => {
  const toggleBtn = document.getElementById("theme-toggle");

  if (!toggleBtn) return;

  const updateLabel = (isDark) => {
    toggleBtn.innerHTML = isDark
      ? " Light Mode"
      : " Dark Mode";
  };

  const savedTheme = localStorage.getItem("theme");

  if (savedTheme === "dark") {
    document.documentElement.setAttribute("data-theme", "dark");
    updateLabel(true);
  } else {
    updateLabel(false);
  }

  toggleBtn.addEventListener("click", () => {
    const isDark = document.documentElement.getAttribute("data-theme") === "dark";

    if (isDark) {
      document.documentElement.removeAttribute("data-theme");
      localStorage.setItem("theme", "light");
      updateLabel(false);
    } else {
      document.documentElement.setAttribute("data-theme", "dark");
      localStorage.setItem("theme", "dark");
      updateLabel(true);
    }
  });
});

document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll(".star");
  const input = document.getElementById("rating-input");

  if (!stars.length) return;

  stars.forEach((star, index) => {
    star.addEventListener("click", () => {
      const value = index + 1;
      input.value = value;

      stars.forEach((s, i) => {
        s.classList.toggle("active", i < value);
        s.textContent = i < value ? "★" : "☆";
      });
    });

    star.addEventListener("mouseover", () => {
      stars.forEach((s, i) => {
        s.textContent = i <= index ? "★" : "☆";
      });
    });

    star.addEventListener("mouseleave", () => {
      const current = input.value;

      stars.forEach((s, i) => {
        s.textContent = i < current ? "★" : "☆";
      });
    });
  });
});