#!/usr/bin/env python3
"""
BFO Site Audit - Blog Post Fixes
Implements: FIX 1, 4, 5, 6, 9, plus footer About link
"""
import os
import re
import glob

BLOG_DIR = "/workspace/thebitcoinfamilyoffice/blog"

# Get all blog post HTML files (not index.html)
blog_files = sorted([
    f for f in glob.glob(os.path.join(BLOG_DIR, "*.html"))
    if not f.endswith("/index.html")
])

print(f"Found {len(blog_files)} blog post files")

# ─────────────────────────────────────────────────
# FIX 1: Author Box HTML (inserted BEFORE services-cta)
# ─────────────────────────────────────────────────
AUTHOR_BOX = '''<div class="author-box" style="max-width:var(--max-w);margin:0 auto 2rem;padding:1.5rem 2rem;background:var(--bg-elevated);border:1px solid var(--accent-border);border-radius:4px;display:flex;gap:1.5rem;align-items:flex-start;">
  <div style="flex-shrink:0;width:48px;height:48px;border-radius:50%;background:var(--accent-dim);border:1px solid var(--accent-border);display:flex;align-items:center;justify-content:center;font-family:var(--sans);font-size:1rem;color:var(--accent);">&#x20BF;</div>
  <div>
    <p style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.12em;text-transform:uppercase;color:var(--accent);margin-bottom:0.3rem;">The Bitcoin Family Office Research Team</p>
    <p style="font-family:var(--serif);font-size:0.9rem;color:var(--text-secondary);line-height:1.7;margin:0;">Our research team focuses exclusively on Bitcoin wealth management &mdash; custody architecture, estate planning, tax strategy, and multi-generational stewardship. We do not advise on altcoins or fiat instruments. <a href="/about/" style="color:var(--accent);text-decoration:none;">About us &rarr;</a></p>
  </div>
</div>
'''

# ─────────────────────────────────────────────────
# FIX 4: Breadcrumb + Reading Time
# ─────────────────────────────────────────────────
BREADCRUMB_META = '''  <p class="article-meta" style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-muted);margin-bottom:2rem;padding-bottom:1rem;border-bottom:1px solid var(--border);">
    <a href="/" style="color:var(--text-muted);text-decoration:none;">Home</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <a href="/blog/" style="color:var(--text-muted);text-decoration:none;">Research</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <span style="color:var(--text-secondary);">Article</span>
    <span style="margin-left:1.5rem;padding-left:1.5rem;border-left:1px solid var(--border);">Est. 8 min read</span>
  </p>
'''

# ─────────────────────────────────────────────────
# FIX 5: Related Reading Section
# ─────────────────────────────────────────────────
RELATED_READING = '''<div style="max-width:var(--max-w);margin:0 auto 2rem;padding:0 1.5rem;">
  <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.15em;text-transform:uppercase;color:var(--text-muted);margin-bottom:1.25rem;">Related Reading</p>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;">
    <a href="/blog/bitcoin-custody-architecture.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor=\'var(--accent-border)\'" onmouseout="this.style.borderColor=\'var(--border)\'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Custody</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Custody Architecture for Family Offices</p>
    </a>
    <a href="/blog/complete-guide-bitcoin-family-offices.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor=\'var(--accent-border)\'" onmouseout="this.style.borderColor=\'var(--border)\'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Overview</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">The Complete Guide to Bitcoin Family Offices</p>
    </a>
    <a href="/blog/bitcoin-estate-planning-complete-guide.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor=\'var(--accent-border)\'" onmouseout="this.style.borderColor=\'var(--border)\'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Estate Planning</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Estate Planning: The Complete Guide</p>
    </a>
  </div>
</div>
'''

# ─────────────────────────────────────────────────
# FIX 6: Optimized titles and descriptions per file
# ─────────────────────────────────────────────────
META_OVERRIDES = {
    "bitcoin-charitable-remainder-trust.html": {
        "title": "Bitcoin Charitable Remainder Trusts: Tax-Smart Philanthropy for Bitcoin Holders | The Bitcoin Family Office",
        "description": "Learn how Bitcoin holders can use Charitable Remainder Trusts (CRTs) to defer capital gains, generate income, and build a philanthropic legacy. A complete family office guide."
    },
    "bitcoin-custody-architecture.html": {
        "title": "Bitcoin Custody Architecture for Family Offices: The Complete Framework | The Bitcoin Family Office",
        "description": "A deep-dive into Bitcoin custody architecture — from single-sig cold storage to distributed multisig quorums. Design decisions that protect significant generational wealth."
    },
    "bitcoin-custody-solutions-family-offices.html": {
        "title": "Bitcoin Custody Solutions for Family Offices: Choosing the Right Structure | The Bitcoin Family Office",
        "description": "Compare institutional, self-custody, and hybrid Bitcoin custody solutions for family offices. Understand the tradeoffs that matter most for high-net-worth Bitcoin holders."
    },
    "bitcoin-direct-ownership-vs-etf-tax.html": {
        "title": "Bitcoin Direct Ownership vs. ETF: Tax Implications for High-Net-Worth Investors | The Bitcoin Family Office",
        "description": "Direct Bitcoin ownership versus ETF exposure — a detailed tax analysis. Understand cost basis, loss harvesting, estate treatment, and why structure matters at scale."
    },
    "bitcoin-estate-planning-arizona.html": {
        "title": "Bitcoin Estate Planning in Arizona: Laws, Trusts & Digital Asset Succession | The Bitcoin Family Office",
        "description": "How Arizona law treats Bitcoin in estates, trusts, and inheritance. A complete guide to structuring Bitcoin succession for Arizona residents holding significant wealth."
    },
    "bitcoin-estate-planning-california.html": {
        "title": "Bitcoin Estate Planning in California: Succession, Trusts & Tax Strategy | The Bitcoin Family Office",
        "description": "California's estate and tax rules for Bitcoin holders. Understand probate avoidance, community property, capital gains, and how to structure multi-generational Bitcoin wealth in CA."
    },
    "bitcoin-estate-planning-colorado.html": {
        "title": "Bitcoin Estate Planning in Colorado: Trusts, Succession & Digital Asset Law | The Bitcoin Family Office",
        "description": "Colorado estate planning for Bitcoin holders. Covers RUFADAA compliance, trust structures, and succession strategies for preserving Bitcoin wealth across generations."
    },
    "bitcoin-estate-planning-complete-guide.html": {
        "title": "Bitcoin Estate Planning Guide for High-Net-Worth Families | The Bitcoin Family Office",
        "description": "The complete guide to Bitcoin estate planning — covering custody handoff, multisig inheritance, trust structures, tax strategy, and generational stewardship for significant holders."
    },
    "bitcoin-estate-planning-florida.html": {
        "title": "Bitcoin Estate Planning in Florida: No Income Tax, Strong Trust Laws & Succession | The Bitcoin Family Office",
        "description": "Florida's favorable estate environment for Bitcoin holders. No state income or estate tax, strong trust statutes, and homestead rules — a complete succession planning guide."
    },
    "bitcoin-estate-planning-nevada.html": {
        "title": "Bitcoin Estate Planning in Nevada: Dynasty Trusts & Asset Protection | The Bitcoin Family Office",
        "description": "Nevada's dynasty trust laws and asset protection statutes make it a premier state for Bitcoin succession planning. A complete guide for high-net-worth Bitcoin families."
    },
    "bitcoin-estate-planning-new-york.html": {
        "title": "Bitcoin Estate Planning in New York: Estate Tax, Trusts & Digital Asset Succession | The Bitcoin Family Office",
        "description": "New York's estate tax cliff and trust rules have major implications for Bitcoin holders. Learn how to structure succession, minimize estate tax, and protect generational wealth in NY."
    },
    "bitcoin-estate-planning-oregon.html": {
        "title": "Bitcoin Estate Planning in Oregon: Succession, Trusts & Digital Asset Law | The Bitcoin Family Office",
        "description": "Oregon estate planning for Bitcoin holders. A practical guide to trust structures, inheritance protocols, and digital asset succession under Oregon law."
    },
    "bitcoin-estate-planning-south-dakota.html": {
        "title": "Bitcoin Estate Planning in South Dakota: Dynasty Trusts & Zero-Tax Advantages | The Bitcoin Family Office",
        "description": "South Dakota's perpetual dynasty trusts, no state income tax, and strong privacy laws make it ideal for Bitcoin family office structures. Complete succession planning guide."
    },
    "bitcoin-estate-planning-tennessee.html": {
        "title": "Bitcoin Estate Planning in Tennessee: Trusts, Succession & Digital Asset Strategy | The Bitcoin Family Office",
        "description": "Tennessee estate planning for Bitcoin holders. Covers Hall Income Tax repeal, trust structures, and digital asset succession for families preserving generational Bitcoin wealth."
    },
    "bitcoin-estate-planning-texas.html": {
        "title": "Bitcoin Estate Planning in Texas: Community Property, Trusts & Succession | The Bitcoin Family Office",
        "description": "Texas Bitcoin estate planning — community property rules, no state income or estate tax, and strong trust statutes. The complete guide for Texas Bitcoin families."
    },
    "bitcoin-estate-planning-washington.html": {
        "title": "Bitcoin Estate Planning in Washington State: Estate Tax & Succession Planning | The Bitcoin Family Office",
        "description": "Washington State has one of the lowest estate tax thresholds in the US. Learn how Bitcoin holders can structure trusts and succession to minimize exposure and protect heirs."
    },
    "bitcoin-estate-planning-wyoming.html": {
        "title": "Bitcoin Estate Planning in Wyoming: The Premier State for Bitcoin Family Offices | The Bitcoin Family Office",
        "description": "Wyoming offers the strongest digital asset property rights, DAO LLCs, and perpetual trust laws in the US. The complete Bitcoin estate planning guide for Wyoming residents and structures."
    },
    "bitcoin-family-constitution.html": {
        "title": "Bitcoin Family Constitution: Governance Framework for Multi-Generational Wealth | The Bitcoin Family Office",
        "description": "How to create a family constitution that governs Bitcoin custody, spending, inheritance, and decision-making across generations. A practical framework for Bitcoin-native families."
    },
    "bitcoin-family-office-cost.html": {
        "title": "Bitcoin Family Office Cost: What It Actually Costs to Run a Bitcoin Family Office | The Bitcoin Family Office",
        "description": "A transparent breakdown of Bitcoin family office costs — setup, ongoing advisory, custody infrastructure, legal, and governance. What to expect at different holding levels."
    },
    "bitcoin-family-office-governance.html": {
        "title": "Bitcoin Family Office Governance: Decision-Making Frameworks for Significant Holders | The Bitcoin Family Office",
        "description": "Build a governance framework for your Bitcoin family office. Investment policy, custody protocols, succession rules, and family decision-making structures that endure across generations."
    },
    "bitcoin-family-office-vs-wealth-manager.html": {
        "title": "Bitcoin Family Office vs. Traditional Wealth Manager: Why Structure Matters | The Bitcoin Family Office",
        "description": "Why traditional wealth managers are structurally ill-equipped to serve Bitcoin families. The case for a Bitcoin-native family office framework over legacy wealth management."
    },
    "bitcoin-fiduciary-duty-trustee.html": {
        "title": "Fiduciary Duty and Bitcoin: What Trustees Need to Know | The Bitcoin Family Office",
        "description": "Can a trustee hold Bitcoin? What fiduciary duty means for Bitcoin-holding trusts — prudent investor standards, documentation requirements, and custody protocol for trustees."
    },
    "bitcoin-generational-wealth-transfer.html": {
        "title": "Bitcoin Generational Wealth Transfer: Passing Bitcoin to the Next Generation | The Bitcoin Family Office",
        "description": "How to structure Bitcoin wealth transfer across generations — trust design, custody handoff protocols, education frameworks, and estate tax strategies for significant Bitcoin holdings."
    },
    "bitcoin-grat-grantor-retained-annuity-trust.html": {
        "title": "Bitcoin GRATs: Using Grantor Retained Annuity Trusts to Transfer Bitcoin Wealth | The Bitcoin Family Office",
        "description": "How Grantor Retained Annuity Trusts (GRATs) can transfer Bitcoin appreciation to heirs with minimal gift tax. The mechanics, risks, and ideal scenarios for Bitcoin GRAT strategies."
    },
    "bitcoin-inheritance-planning.html": {
        "title": "Bitcoin Inheritance Planning: A Complete Guide to Passing Bitcoin to Your Heirs | The Bitcoin Family Office",
        "description": "The most comprehensive guide to Bitcoin inheritance planning — from dead man's switch protocols to multisig key handoff, trustee education, and estate tax minimization strategies."
    },
    "bitcoin-investment-policy-statement.html": {
        "title": "Bitcoin Investment Policy Statement for Family Offices: A Practical Framework | The Bitcoin Family Office",
        "description": "How to write a Bitcoin Investment Policy Statement (IPS) for a family office. Covers allocation rationale, custody standards, rebalancing rules, and governance documentation."
    },
    "bitcoin-ira-family-office.html": {
        "title": "Bitcoin IRAs and Self-Directed Retirement Accounts: A Family Office Guide | The Bitcoin Family Office",
        "description": "How high-net-worth Bitcoin holders can use self-directed IRAs, Solo 401(k)s, and retirement accounts as part of a broader Bitcoin family office tax strategy."
    },
    "bitcoin-multisig-family-office-custody.html": {
        "title": "Multi-Signature Bitcoin Custody for Family Offices: Architecture & Implementation | The Bitcoin Family Office",
        "description": "The definitive guide to multisig Bitcoin custody for family offices — key ceremony design, quorum structures, geographic distribution, and operational security protocols."
    },
    "bitcoin-prenuptial-agreement.html": {
        "title": "Bitcoin Prenuptial Agreements: Protecting Bitcoin Wealth Before Marriage | The Bitcoin Family Office",
        "description": "How to protect Bitcoin holdings in a prenuptial agreement. Covers Bitcoin characterization, valuation timing, community vs. separate property, and enforcement across jurisdictions."
    },
    "bitcoin-tax-optimization-high-net-worth.html": {
        "title": "Bitcoin Tax Optimization for High-Net-Worth Holders: Advanced Strategies | The Bitcoin Family Office",
        "description": "Advanced Bitcoin tax strategies for significant holders — loss harvesting, long-term rate optimization, charitable giving, trust structures, and estate planning to minimize lifetime tax burden."
    },
    "bitcoin-wealth-preservation-strategy.html": {
        "title": "Bitcoin Wealth Preservation Strategy: A Framework for Long-Duration Holders | The Bitcoin Family Office",
        "description": "How to build a Bitcoin wealth preservation strategy — custody architecture, estate structures, inflation protection, and governance frameworks for families holding Bitcoin across decades."
    },
    "bitcoin-wyoming-trust-llc.html": {
        "title": "Wyoming Bitcoin Trust LLCs: Structure, Benefits & Setup Guide | The Bitcoin Family Office",
        "description": "Wyoming's DAO LLC and trust laws create a powerful structure for Bitcoin family offices. Learn how to form, structure, and operate a Wyoming Bitcoin Trust LLC for generational wealth."
    },
    "building-bitcoin-native-family-office.html": {
        "title": "Building a Bitcoin-Native Family Office: A Complete Setup Guide | The Bitcoin Family Office",
        "description": "How to build a Bitcoin-native family office from the ground up — governance structure, custody architecture, legal entities, advisors, and the frameworks that distinguish Bitcoin family offices from legacy wealth management."
    },
    "complete-guide-bitcoin-family-offices.html": {
        "title": "The Complete Guide to Bitcoin Family Offices for High-Net-Worth Holders | The Bitcoin Family Office",
        "description": "Everything you need to know about Bitcoin family offices — what they are, how they work, the services they provide, and why they exist. The definitive primer for significant Bitcoin holders."
    },
    "multi-generational-bitcoin-wealth-estate-planning.html": {
        "title": "Multi-Generational Bitcoin Wealth: Estate Planning for Dynasties | The Bitcoin Family Office",
        "description": "How to structure Bitcoin wealth to survive and grow across multiple generations — dynasty trusts, governance constitutions, custody succession protocols, and family education frameworks."
    },
}

def get_canonical_url(content):
    """Extract canonical URL from HTML content."""
    match = re.search(r'<link rel="canonical" href="([^"]+)"', content)
    if match:
        return match.group(1)
    return None

def apply_fixes(filepath):
    filename = os.path.basename(filepath)
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    changes = []
    
    # ─── FIX 4: Add breadcrumb after <article class="article-body"> ───
    ARTICLE_OPEN = '<article class="article-body">'
    if ARTICLE_OPEN in content and 'article-meta' not in content:
        content = content.replace(
            ARTICLE_OPEN,
            ARTICLE_OPEN + '\n' + BREADCRUMB_META,
            1
        )
        changes.append("FIX4: breadcrumb+read-time")
    
    # ─── FIX 5: Add Related Reading BEFORE author-box placeholder, after </article> ───
    # We'll insert it before the author-box (which FIX1 will add), but since 
    # we're doing them in sequence, insert before services-cta if author-box not yet present
    ARTICLE_CLOSE = '</article>\n\n<div class="services-cta">'
    ARTICLE_CLOSE_ALT = '</article>\n<div class="services-cta">'
    
    if 'Related Reading' not in content:
        if ARTICLE_CLOSE in content:
            content = content.replace(
                ARTICLE_CLOSE,
                '</article>\n\n' + RELATED_READING + '\n<div class="services-cta">',
                1
            )
            changes.append("FIX5: related reading")
        elif ARTICLE_CLOSE_ALT in content:
            content = content.replace(
                ARTICLE_CLOSE_ALT,
                '</article>\n\n' + RELATED_READING + '\n<div class="services-cta">',
                1
            )
            changes.append("FIX5: related reading (alt)")
        else:
            # Try to find </article> followed by whatever and then services-cta
            match = re.search(r'(</article>\s*)', content)
            if match and 'services-cta' in content[match.end():match.end()+200]:
                pos = match.end()
                content = content[:pos] + '\n' + RELATED_READING + '\n' + content[pos:]
                changes.append("FIX5: related reading (regex)")
    
    # ─── FIX 1: Add author box BEFORE <div class="services-cta"> ───
    CTA_OPEN = '<div class="services-cta">'
    if CTA_OPEN in content and 'author-box' not in content:
        content = content.replace(
            CTA_OPEN,
            AUTHOR_BOX + '\n' + CTA_OPEN,
            1
        )
        changes.append("FIX1: author-box")
    
    # ─── FIX 6: Update title and meta description ───
    if filename in META_OVERRIDES:
        meta = META_OVERRIDES[filename]
        
        # Update <title>
        new_title_tag = f'<title>{meta["title"]}</title>'
        content = re.sub(r'<title>[^<]+</title>', new_title_tag, content, count=1)
        
        # Update og:title
        new_og_title = f'<meta property="og:title" content="{meta["title"].split(" | ")[0]}">'
        content = re.sub(r'<meta property="og:title" content="[^"]*">', new_og_title, content, count=1)
        
        # Update meta description
        new_desc_tag = f'<meta name="description" content="{meta["description"]}">'
        content = re.sub(r'<meta name="description" content="[^"]*">', new_desc_tag, content, count=1)
        
        # Update og:description
        new_og_desc = f'<meta property="og:description" content="{meta["description"]}">'
        content = re.sub(r'<meta property="og:description" content="[^"]*">', new_og_desc, content, count=1)
        
        changes.append("FIX6: title+description")
    
    # ─── FIX 9: Add BreadcrumbList schema ───
    canonical_url = get_canonical_url(content)
    if canonical_url and 'BreadcrumbList' not in content:
        breadcrumb_schema = f'''<script type="application/ld+json">
{{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {{"@type": "ListItem", "position": 1, "name": "Home", "item": "https://thebitcoinfamilyoffice.com"}},
    {{"@type": "ListItem", "position": 2, "name": "Research", "item": "https://thebitcoinfamilyoffice.com/blog/"}},
    {{"@type": "ListItem", "position": 3, "name": "Article", "item": "{canonical_url}"}}
  ]
}}
</script>
'''
        # Insert after the existing JSON-LD Article schema
        # Find end of first <script type="application/ld+json">...</script>
        match = re.search(r'(</script>)(\s*\n\s*<!-- Google Analytics)', content)
        if match:
            content = content[:match.start(1)] + '</script>\n\n' + breadcrumb_schema + content[match.start(2):]
            changes.append("FIX9: BreadcrumbList schema")
        else:
            # Try to insert after first ld+json block
            match2 = re.search(r'(</script>)(\s*\n(?!\s*<script))', content)
            if match2:
                content = content[:match2.end(1)] + '\n\n' + breadcrumb_schema + content[match2.start(2):]
                changes.append("FIX9: BreadcrumbList schema (alt)")
    
    # ─── FIX 10: Add About to footer-links ───
    footer_pattern = r'(<div class="footer-links">)(.*?)(</div>)'
    def add_about_to_footer(m):
        links_html = m.group(2)
        if '/about/' not in links_html and 'About' not in links_html:
            # Add About link after the first <a> tag or at start
            about_link = '\n    <a href="/about/">About</a>'
            links_html = about_link + links_html
        return m.group(1) + links_html + m.group(3)
    
    new_content = re.sub(footer_pattern, add_about_to_footer, content, count=1, flags=re.DOTALL)
    if new_content != content:
        content = new_content
        changes.append("FIX10: About footer link")
    
    # ─── Write if changed ───
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  ✓ {filename}: {', '.join(changes)}")
    else:
        print(f"  ~ {filename}: no changes needed")
    
    return len(changes) > 0

# Process all blog posts
changed = 0
for fpath in blog_files:
    if apply_fixes(fpath):
        changed += 1

print(f"\nDone. Modified {changed}/{len(blog_files)} blog post files.")
