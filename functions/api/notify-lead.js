// BFO Lead Notification — emails wyatt@basilic.io on every qualify form submission
// Triggered by the qualify form's progressive save AND full submit

export async function onRequestPost(context) {
  const { request, env } = context;
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json',
  };

  try {
    const body = await request.json();
    const { name, email, phone, partial, total_assets, btc_pct, state, services, urgent_need, timeline, current_advisors, advisor_bitcoin_exp, referral_source } = body;

    if (!email) {
      return new Response(JSON.stringify({ error: 'No email' }), { status: 400, headers });
    }

    // Build notification email
    const isPartial = partial === true || partial === 'true';
    const subject = isPartial 
      ? `🔔 New BFO Lead (partial): ${name || email}`
      : `🔔 New BFO Qualified Lead: ${name || email}`;

    const details = [];
    if (name) details.push(`<strong>Name:</strong> ${name}`);
    if (email) details.push(`<strong>Email:</strong> ${email}`);
    if (phone) details.push(`<strong>Phone:</strong> ${phone}`);
    if (referral_source) details.push(`<strong>Referral:</strong> ${referral_source}`);
    if (total_assets) details.push(`<strong>Total Assets:</strong> ${total_assets}`);
    if (btc_pct) details.push(`<strong>BTC % of Net Worth:</strong> ${btc_pct}`);
    if (state) details.push(`<strong>State:</strong> ${state}`);
    if (current_advisors) details.push(`<strong>Current Advisors:</strong> ${current_advisors}`);
    if (advisor_bitcoin_exp) details.push(`<strong>Advisors Bitcoin-Native?:</strong> ${advisor_bitcoin_exp}`);
    if (services) details.push(`<strong>Services Requested:</strong> ${Array.isArray(services) ? services.join(', ') : services}`);
    if (timeline) details.push(`<strong>Timeline:</strong> ${timeline}`);
    if (urgent_need) details.push(`<strong>Urgent Need:</strong> ${urgent_need}`);

    const html = `
      <div style="font-family:sans-serif;max-width:600px;">
        <h2 style="color:#c9a84c;margin-bottom:16px;">${isPartial ? '📋 New Lead (started form)' : '✅ Qualified Lead Submitted'}</h2>
        <div style="background:#f5f5f5;padding:20px;border-radius:8px;line-height:1.8;">
          ${details.join('<br>')}
        </div>
        <p style="margin-top:16px;color:#666;font-size:13px;">
          ${isPartial ? 'This person started the qualify form but may not have finished. Contact info captured.' : 'Full qualification form completed.'}
          <br>View all leads: <a href="https://docs.google.com/spreadsheets/d/1PFN6798J1_FS2cXqsn-z8PZAAXsp7lOZXAGCK2meRJQ/edit">BFO Waitlist Sheet</a>
          <br>Pipeline CRM: <a href="https://docs.google.com/spreadsheets/d/1xLxEr6z3sxgZtDMj1g2Qwp8c2-GAshtmuRWUuPwD9aA/edit">Client Pipeline</a>
        </p>
      </div>`;

    // Send via Cloudflare Email Workers or external SMTP
    // For now, store the notification request — Hal's cron will pick it up and send via gog gmail
    // We'll use a simple KV or D1 approach
    
    // Actually, let's try sending directly via Gmail API if we have a token
    // Fallback: just log it and the cron picks it up
    
    // For immediate delivery: use the Resend API from warpreader.com domain
    // (cross-brand but functional — "leads@warpreader.com" as sender)
    if (env.RESEND_API_KEY) {
      const emailResp = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${env.RESEND_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: 'BFO Leads <hal@warpreader.com>',
          to: ['wyatt@basilic.io'],
          cc: ['halabundance@gmail.com'],
          subject,
          html,
        }),
      });
      const emailResult = await emailResp.json();
      return new Response(JSON.stringify({ success: true, email_sent: emailResp.ok, detail: emailResult }), { status: 200, headers });
    }

    return new Response(JSON.stringify({ success: true, email_sent: false, reason: 'No RESEND_API_KEY configured' }), { status: 200, headers });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500, headers });
  }
}

export async function onRequestOptions() {
  return new Response(null, {
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  });
}
