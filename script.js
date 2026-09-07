const lines = [
  "SELECT role, focus",
  "FROM   bochic",
  "WHERE  based_in = 'Kyoto, Japan';",
  "",
  " role  | Data Analytics Lead",
  " focus | dashboards, pipelines, and",
  "       | data models people can trust"
];

const target = document.getElementById("typedQuery");
const fullText = lines.join("\n");
const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

if (!target) {
  // Nothing to animate.
} else if (prefersReducedMotion) {
  target.textContent = fullText;
} else {
  let i = 0;
  const speed = 18; // ms per character

  function typeNext() {
    if (i <= fullText.length) {
      target.textContent = fullText.slice(0, i);
      i++;
      setTimeout(typeNext, speed);
    }
  }

  typeNext();
}
