#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use File::Glob ':glob';

my $BLOG_DIR = "/workspace/thebitcoinfamilyoffice/blog";

# Get all blog post HTML files (not index.html)
my @blog_files = sort grep { !/\/index\.html$/ } glob("$BLOG_DIR/*.html");
print "Found " . scalar(@blog_files) . " blog post files\n";

# ─── FIX 1: Author Box ───
my $AUTHOR_BOX = <<'AUTHORBOX';
<div class="author-box" style="max-width:var(--max-w);margin:0 auto 2rem;padding:1.5rem 2rem;background:var(--bg-elevated);border:1px solid var(--accent-border);border-radius:4px;display:flex;gap:1.5rem;align-items:flex-start;">
  <div style="flex-shrink:0;width:48px;height:48px;border-radius:50%;background:var(--accent-dim);border:1px solid var(--accent-border);display:flex;align-items:center;justify-content:center;font-family:var(--sans);font-size:1rem;color:var(--accent);">&#x20BF;</div>
  <div>
    <p style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.12em;text-transform:uppercase;color:var(--accent);margin-bottom:0.3rem;">The Bitcoin Family Office Research Team</p>
    <p style="font-family:var(--serif);font-size:0.9rem;color:var(--text-secondary);line-height:1.7;margin:0;">Our research team focuses exclusively on Bitcoin wealth management &mdash; custody architecture, estate planning, tax strategy, and multi-generational stewardship. We do not advise on altcoins or fiat instruments. <a href="/about/" style="color:var(--accent);text-decoration:none;">About us &rarr;</a></p>
  </div>
</div>

AUTHORBOX

# ─── FIX 4: Breadcrumb + Reading Time ───
my $BREADCRUMB_META = <<'BREADCRUMB';
  <p class="article-meta" style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-muted);margin-bottom:2rem;padding-bottom:1rem;border-bottom:1px solid var(--border);">
    <a href="/" style="color:var(--text-muted);text-decoration:none;">Home</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <a href="/blog/" style="color:var(--text-muted);text-decoration:none;">Research</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <span style="color:var(--text-secondary);">Article</span>
    <span style="margin-left:1.5rem;padding-left:1.5rem;border-left:1px solid var(--border);">Est. 8 min read</span>
  </p>
BREADCRUMB

# ─── FIX 5: Related Reading ───
my $RELATED_READING = <<'RELATED';
<div style="max-width:var(--max-w);margin:0 auto 2rem;padding:0 1.5rem;">
  <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.15em;text-transform:uppercase;color:var(--text-muted);margin-bottom:1.25rem;">Related Reading</p>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;">
    <a href="/blog/bitcoin-custody-architecture.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Custody</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Custody Architecture for Family Offices</p>
    </a>
    <a href="/blog/complete-guide-bitcoin-family-offices.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Overview</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">The Complete Guide to Bitcoin Family Offices</p>
    </a>
    <a href="/blog/bitcoin-estate-planning-complete-guide.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Estate Planning</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Estate Planning: The Complete Guide</p>
    </a>
  </div>
</div>

RELATED

# ─── FIX 6: Meta overrides ───
my %META = (
    "bitcoin-charitable-remainder-trust.html" => {
        title => "Bitcoin Charitable Remainder Trusts: Tax-Smart Philanthropy for Bitcoin Holders | The Bitcoin Family Office",
        desc  => "Learn how Bitcoin holders can use Charitable Remainder Trusts (CRTs) to defer capital gains, generate income, and build a philanthropic legacy. A complete family office guide.",
    },
    "bitcoin-custody-architecture.html" => {
        title => "Bitcoin Custody Architecture for Family Offices: The Complete Framework | The Bitcoin Family Office",
        desc  => "A deep-dive into Bitcoin custody architecture — from single-sig cold storage to distributed multisig quorums. Design decisions that protect significant generational wealth.",
    },
    "bitcoin-custody-solutions-family-offices.html" => {
        title => "Bitcoin Custody Solutions for Family Offices: Choosing the Right Structure | The Bitcoin Family Office",
        desc  => "Compare institutional, self-custody, and hybrid Bitcoin custody solutions for family offices. Understand the tradeoffs that matter most for high-net-worth Bitcoin holders.",
    },
    "bitcoin-direct-ownership-vs-etf-tax.html" => {
        title => "Bitcoin Direct Ownership vs. ETF: Tax Implications for High-Net-Worth Investors | The Bitcoin Family Office",
        desc  => "Direct Bitcoin ownership versus ETF exposure — a detailed tax analysis. Understand cost basis, loss harvesting, estate treatment, and why structure matters at scale.",
    },
    "bitcoin-estate-planning-arizona.html" => {
        title => "Bitcoin Estate Planning in Arizona: Laws, Trusts & Digital Asset Succession | The Bitcoin Family Office",
        desc  => "How Arizona law treats Bitcoin in estates, trusts, and inheritance. A complete guide to structuring Bitcoin succession for Arizona residents holding significant wealth.",
    },
    "bitcoin-estate-planning-california.html" => {
        title => "Bitcoin Estate Planning in California: Succession, Trusts & Tax Strategy | The Bitcoin Family Office",
        desc  => "California's estate and tax rules for Bitcoin holders. Understand probate avoidance, community property, capital gains, and how to structure multi-generational Bitcoin wealth in CA.",
    },
    "bitcoin-estate-planning-colorado.html" => {
        title => "Bitcoin Estate Planning in Colorado: Trusts, Succession & Digital Asset Law | The Bitcoin Family Office",
        desc  => "Colorado estate planning for Bitcoin holders. Covers RUFADAA compliance, trust structures, and succession strategies for preserving Bitcoin wealth across generations.",
    },
    "bitcoin-estate-planning-complete-guide.html" => {
        title => "Bitcoin Estate Planning Guide for High-Net-Worth Families | The Bitcoin Family Office",
        desc  => "The complete guide to Bitcoin estate planning — covering custody handoff, multisig inheritance, trust structures, tax strategy, and generational stewardship for significant holders.",
    },
    "bitcoin-estate-planning-florida.html" => {
        title => "Bitcoin Estate Planning in Florida: No Income Tax, Strong Trust Laws & Succession | The Bitcoin Family Office",
        desc  => "Florida's favorable estate environment for Bitcoin holders. No state income or estate tax, strong trust statutes, and homestead rules — a complete succession planning guide.",
    },
    "bitcoin-estate-planning-nevada.html" => {
        title => "Bitcoin Estate Planning in Nevada: Dynasty Trusts & Asset Protection | The Bitcoin Family Office",
        desc  => "Nevada's dynasty trust laws and asset protection statutes make it a premier state for Bitcoin succession planning. A complete guide for high-net-worth Bitcoin families.",
    },
    "bitcoin-estate-planning-new-york.html" => {
        title => "Bitcoin Estate Planning in New York: Estate Tax, Trusts & Digital Asset Succession | The Bitcoin Family Office",
        desc  => "New York's estate tax cliff and trust rules have major implications for Bitcoin holders. Learn how to structure succession, minimize estate tax, and protect generational wealth in NY.",
    },
    "bitcoin-estate-planning-oregon.html" => {
        title => "Bitcoin Estate Planning in Oregon: Succession, Trusts & Digital Asset Law | The Bitcoin Family Office",
        desc  => "Oregon estate planning for Bitcoin holders. A practical guide to trust structures, inheritance protocols, and digital asset succession under Oregon law.",
    },
    "bitcoin-estate-planning-south-dakota.html" => {
        title => "Bitcoin Estate Planning in South Dakota: Dynasty Trusts & Zero-Tax Advantages | The Bitcoin Family Office",
        desc  => "South Dakota's perpetual dynasty trusts, no state income tax, and strong privacy laws make it ideal for Bitcoin family office structures. Complete succession planning guide.",
    },
    "bitcoin-estate-planning-tennessee.html" => {
        title => "Bitcoin Estate Planning in Tennessee: Trusts, Succession & Digital Asset Strategy | The Bitcoin Family Office",
        desc  => "Tennessee estate planning for Bitcoin holders. Covers Hall Income Tax repeal, trust structures, and digital asset succession for families preserving generational Bitcoin wealth.",
    },
    "bitcoin-estate-planning-texas.html" => {
        title => "Bitcoin Estate Planning in Texas: Community Property, Trusts & Succession | The Bitcoin Family Office",
        desc  => "Texas Bitcoin estate planning — community property rules, no state income or estate tax, and strong trust statutes. The complete guide for Texas Bitcoin families.",
    },
    "bitcoin-estate-planning-washington.html" => {
        title => "Bitcoin Estate Planning in Washington State: Estate Tax & Succession Planning | The Bitcoin Family Office",
        desc  => "Washington State has one of the lowest estate tax thresholds in the US. Learn how Bitcoin holders can structure trusts and succession to minimize exposure and protect heirs.",
    },
    "bitcoin-estate-planning-wyoming.html" => {
        title => "Bitcoin Estate Planning in Wyoming: The Premier State for Bitcoin Family Offices | The Bitcoin Family Office",
        desc  => "Wyoming offers the strongest digital asset property rights, DAO LLCs, and perpetual trust laws in the US. The complete Bitcoin estate planning guide for Wyoming residents and structures.",
    },
    "bitcoin-family-constitution.html" => {
        title => "Bitcoin Family Constitution: Governance Framework for Multi-Generational Wealth | The Bitcoin Family Office",
        desc  => "How to create a family constitution that governs Bitcoin custody, spending, inheritance, and decision-making across generations. A practical framework for Bitcoin-native families.",
    },
    "bitcoin-family-office-cost.html" => {
        title => "Bitcoin Family Office Cost: What It Actually Costs to Run a Bitcoin Family Office | The Bitcoin Family Office",
        desc  => "A transparent breakdown of Bitcoin family office costs — setup, ongoing advisory, custody infrastructure, legal, and governance. What to expect at different holding levels.",
    },
    "bitcoin-family-office-governance.html" => {
        title => "Bitcoin Family Office Governance: Decision-Making Frameworks for Significant Holders | The Bitcoin Family Office",
        desc  => "Build a governance framework for your Bitcoin family office. Investment policy, custody protocols, succession rules, and family decision-making structures that endure across generations.",
    },
    "bitcoin-family-office-vs-wealth-manager.html" => {
        title => "Bitcoin Family Office vs. Traditional Wealth Manager: Why Structure Matters | The Bitcoin Family Office",
        desc  => "Why traditional wealth managers are structurally ill-equipped to serve Bitcoin families. The case for a Bitcoin-native family office framework over legacy wealth management.",
    },
    "bitcoin-fiduciary-duty-trustee.html" => {
        title => "Fiduciary Duty and Bitcoin: What Trustees Need to Know | The Bitcoin Family Office",
        desc  => "Can a trustee hold Bitcoin? What fiduciary duty means for Bitcoin-holding trusts — prudent investor standards, documentation requirements, and custody protocol for trustees.",
    },
    "bitcoin-generational-wealth-transfer.html" => {
        title => "Bitcoin Generational Wealth Transfer: Passing Bitcoin to the Next Generation | The Bitcoin Family Office",
        desc  => "How to structure Bitcoin wealth transfer across generations — trust design, custody handoff protocols, education frameworks, and estate tax strategies for significant Bitcoin holdings.",
    },
    "bitcoin-grat-grantor-retained-annuity-trust.html" => {
        title => "Bitcoin GRATs: Using Grantor Retained Annuity Trusts to Transfer Bitcoin Wealth | The Bitcoin Family Office",
        desc  => "How Grantor Retained Annuity Trusts (GRATs) can transfer Bitcoin appreciation to heirs with minimal gift tax. The mechanics, risks, and ideal scenarios for Bitcoin GRAT strategies.",
    },
    "bitcoin-inheritance-planning.html" => {
        title => "Bitcoin Inheritance Planning: A Complete Guide to Passing Bitcoin to Your Heirs | The Bitcoin Family Office",
        desc  => "The most comprehensive guide to Bitcoin inheritance planning — from dead man's switch protocols to multisig key handoff, trustee education, and estate tax minimization strategies.",
    },
    "bitcoin-investment-policy-statement.html" => {
        title => "Bitcoin Investment Policy Statement for Family Offices: A Practical Framework | The Bitcoin Family Office",
        desc  => "How to write a Bitcoin Investment Policy Statement (IPS) for a family office. Covers allocation rationale, custody standards, rebalancing rules, and governance documentation.",
    },
    "bitcoin-ira-family-office.html" => {
        title => "Bitcoin IRAs and Self-Directed Retirement Accounts: A Family Office Guide | The Bitcoin Family Office",
        desc  => "How high-net-worth Bitcoin holders can use self-directed IRAs, Solo 401(k)s, and retirement accounts as part of a broader Bitcoin family office tax strategy.",
    },
    "bitcoin-multisig-family-office-custody.html" => {
        title => "Multi-Signature Bitcoin Custody for Family Offices: Architecture & Implementation | The Bitcoin Family Office",
        desc  => "The definitive guide to multisig Bitcoin custody for family offices — key ceremony design, quorum structures, geographic distribution, and operational security protocols.",
    },
    "bitcoin-prenuptial-agreement.html" => {
        title => "Bitcoin Prenuptial Agreements: Protecting Bitcoin Wealth Before Marriage | The Bitcoin Family Office",
        desc  => "How to protect Bitcoin holdings in a prenuptial agreement. Covers Bitcoin characterization, valuation timing, community vs. separate property, and enforcement across jurisdictions.",
    },
    "bitcoin-tax-optimization-high-net-worth.html" => {
        title => "Bitcoin Tax Optimization for High-Net-Worth Holders: Advanced Strategies | The Bitcoin Family Office",
        desc  => "Advanced Bitcoin tax strategies for significant holders — loss harvesting, long-term rate optimization, charitable giving, trust structures, and estate planning to minimize lifetime tax burden.",
    },
    "bitcoin-wealth-preservation-strategy.html" => {
        title => "Bitcoin Wealth Preservation Strategy: A Framework for Long-Duration Holders | The Bitcoin Family Office",
        desc  => "How to build a Bitcoin wealth preservation strategy — custody architecture, estate structures, inflation protection, and governance frameworks for families holding Bitcoin across decades.",
    },
    "bitcoin-wyoming-trust-llc.html" => {
        title => "Wyoming Bitcoin Trust LLCs: Structure, Benefits & Setup Guide | The Bitcoin Family Office",
        desc  => "Wyoming's DAO LLC and trust laws create a powerful structure for Bitcoin family offices. Learn how to form, structure, and operate a Wyoming Bitcoin Trust LLC for generational wealth.",
    },
    "building-bitcoin-native-family-office.html" => {
        title => "Building a Bitcoin-Native Family Office: A Complete Setup Guide | The Bitcoin Family Office",
        desc  => "How to build a Bitcoin-native family office from the ground up — governance structure, custody architecture, legal entities, advisors, and the frameworks that distinguish Bitcoin family offices from legacy wealth management.",
    },
    "complete-guide-bitcoin-family-offices.html" => {
        title => "The Complete Guide to Bitcoin Family Offices for High-Net-Worth Holders | The Bitcoin Family Office",
        desc  => "Everything you need to know about Bitcoin family offices — what they are, how they work, the services they provide, and why they exist. The definitive primer for significant Bitcoin holders.",
    },
    "multi-generational-bitcoin-wealth-estate-planning.html" => {
        title => "Multi-Generational Bitcoin Wealth: Estate Planning for Dynasties | The Bitcoin Family Office",
        desc  => "How to structure Bitcoin wealth to survive and grow across multiple generations — dynasty trusts, governance constitutions, custody succession protocols, and family education frameworks.",
    },
);

my $changed = 0;

for my $fpath (@blog_files) {
    my $filename = basename($fpath);
    
    open(my $fh, '<', $fpath) or die "Cannot open $fpath: $!";
    local $/;
    my $content = <$fh>;
    close $fh;
    
    my $original = $content;
    my @changes;
    
    # ─── FIX 4: Breadcrumb after <article class="article-body"> ───
    if ($content =~ /<article class="article-body">/ && $content !~ /article-meta/) {
        $content =~ s|(<article class="article-body">)|$1\n$BREADCRUMB_META|;
        push @changes, "FIX4:breadcrumb";
    }
    
    # ─── FIX 5: Related Reading before services-cta ───
    if ($content !~ /Related Reading/) {
        if ($content =~ s|</article>\s*\n\s*<div class="services-cta">|</article>\n\n${RELATED_READING}<div class="services-cta">|) {
            push @changes, "FIX5:related-reading";
        }
    }
    
    # ─── FIX 1: Author Box before services-cta ───
    if ($content !~ /author-box/) {
        if ($content =~ s|(<div class="services-cta">)|${AUTHOR_BOX}$1|) {
            push @changes, "FIX1:author-box";
        }
    }
    
    # ─── FIX 6: Title + Meta description ───
    if (exists $META{$filename}) {
        my $t = $META{$filename}{title};
        my $d = $META{$filename}{desc};
        # Escape for regex replacement
        (my $t_og = $t) =~ s/ \| The Bitcoin Family Office$//;
        
        $content =~ s|<title>[^<]+</title>|<title>$t</title>|;
        $content =~ s|<meta property="og:title" content="[^"]*">|<meta property="og:title" content="$t_og">|;
        $content =~ s|<meta name="description" content="[^"]*">|<meta name="description" content="$d">|;
        $content =~ s|<meta property="og:description" content="[^"]*">|<meta property="og:description" content="$d">|;
        push @changes, "FIX6:meta";
    }
    
    # ─── FIX 9: BreadcrumbList schema ───
    if ($content !~ /BreadcrumbList/ && $content =~ /link rel="canonical" href="([^"]+)"/) {
        my $canonical = $1;
        my $bc_schema = qq{<script type="application/ld+json">\n{\n  "\@context": "https://schema.org",\n  "\@type": "BreadcrumbList",\n  "itemListElement": [\n    {"\@type": "ListItem", "position": 1, "name": "Home", "item": "https://thebitcoinfamilyoffice.com"},\n    {"\@type": "ListItem", "position": 2, "name": "Research", "item": "https://thebitcoinfamilyoffice.com/blog/"},\n    {"\@type": "ListItem", "position": 3, "name": "Article", "item": "$canonical"}\n  ]\n}\n</script>\n};
        # Insert after the first closing </script> tag (after ld+json block)
        # Find position of first </script> and insert breadcrumb schema after it
        if ($content =~ s|(</script>)(\s*\n\s*\n<!-- Google Analytics)|$1\n\n$bc_schema$2|s) {
            push @changes, "FIX9:breadcrumb-schema";
        } elsif ($content =~ s|(</script>)(\s*\n<!-- Google Analytics)|$1\n\n$bc_schema$2|s) {
            push @changes, "FIX9:breadcrumb-schema-alt";
        }
    }
    
    # ─── FIX 10: About link in footer ───
    if ($content !~ m|href="/about/"| && $content =~ /<div class="footer-links">/) {
        $content =~ s|(<div class="footer-links">\s*\n)|$1    <a href="/about/">About</a>\n|;
        push @changes, "FIX10:about-footer";
    }
    
    # Write if changed
    if ($content ne $original) {
        open(my $out, '>', $fpath) or die "Cannot write $fpath: $!";
        print $out $content;
        close $out;
        $changed++;
        print "  ✓ $filename: " . join(", ", @changes) . "\n";
    } else {
        print "  ~ $filename: no changes\n";
    }
}

print "\nDone. Modified $changed/" . scalar(@blog_files) . " blog post files.\n";
