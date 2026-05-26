// Cloudflare Workers static asset handler with SPA fallback.
// _redirects does NOT work on Cloudflare Workers deployments — this file handles it instead.
// Any path that doesn't match a real static file is served as index.html so
// React Router can handle client-side navigation (including hard refreshes / direct URLs).

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // 1. Try to serve the real static asset first
    try {
      const assetResponse = await env.ASSETS.fetch(request);
      // If the asset exists (not a 404), return it as-is
      if (assetResponse.status !== 404) {
        return assetResponse;
      }
    } catch (_) {
      // ASSETS binding unavailable in local dev — fall through
    }

    // 2. For any unmatched path, serve index.html (SPA fallback)
    const indexRequest = new Request(new URL('/index.html', url.origin), request);
    try {
      const indexResponse = await env.ASSETS.fetch(indexRequest);
      // Return index.html with a 200 so the browser doesn't cache the fallback as a 404
      return new Response(indexResponse.body, {
        status: 200,
        headers: indexResponse.headers,
      });
    } catch (e) {
      return new Response('Not Found', { status: 404 });
    }
  },
};
