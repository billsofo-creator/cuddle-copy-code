import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  component: Index,
  head: () => ({
    meta: [
      { title: "Stellar Tactics — Turn-Based Star Warfare" },
      {
        name: "description",
        content:
          "Stellar Tactics — turn-based star warfare. Deploy fleets, capture worlds, dominate the galaxy.",
      },
    ],
  }),
});

function Index() {
  return (
    <iframe
      src="/game/index.html"
      title="Stellar Tactics"
      style={{
        position: "fixed",
        inset: 0,
        width: "100vw",
        height: "100vh",
        border: 0,
      }}
      allow="fullscreen; autoplay"
    />
  );
}
