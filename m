Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbZKOWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbZKOWiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZKOWiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:38:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58638 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZKOWiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:38:18 -0500
Date: Mon, 16 Nov 2009 09:38:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
Message-Id: <20091116093820.aa5a36b7.sfr@canb.auug.org.au>
In-Reply-To: <20091113175928.GB3684@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
	<1257856848.21596.753.camel@localhost>
	<1257929140.20378.51.camel@tubuntu.research.nokia.com>
	<1257932641.20378.77.camel@tubuntu.research.nokia.com>
	<20091111184208.GC24837@atomide.com>
	<20091112161028.427787d9.sfr@canb.auug.org.au>
	<20091112181457.GX24837@atomide.com>
	<20091113074811.ee61948f.sfr@canb.auug.org.au>
	<1258106168.20378.119.camel@tubuntu.research.nokia.com>
	<20091113175928.GB3684@atomide.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Nov_2009_09_38_20_+1100_n/X=n6l48RMZsTpN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Nov_2009_09_38_20_+1100_n/X=n6l48RMZsTpN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Tomi,

On Fri, 13 Nov 2009 09:59:28 -0800 Tony Lindgren <tony@atomide.com> wrote:
>
> > I rebased DSS2 on top of 8171d88089ad63fc442b2bf32af7c18653adc5cb. It
> > can be found from git://gitorious.org/linux-omap-dss2/linux.git for-next
> > branch.
> >=20
> > I'm ok with Tony pulling DSS2 to his next-branch, or Stephen pulling
> > directly, which ever works easier for you.
>=20
> I'd rather see Stephen pulling directly from Tomi, that's a good long
> term solution for maintaining the DSS2 code.

OK, I have added that branch to linux-next from today.  Thanks for all
the efforts.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__16_Nov_2009_09_38_20_+1100_n/X=n6l48RMZsTpN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksAgtwACgkQjjKRsyhoI8xdqwCfUD3obuFIYephPf3KR43fRQf4
kjkAn2GFoTwHHT0CH5IakQF0mCGJjCCj
=6z9F
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Nov_2009_09_38_20_+1100_n/X=n6l48RMZsTpN--
