Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182Ab0ATAMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0ATAMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738Ab0ATAMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:12:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58633 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0ATAM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:12:29 -0500
Date: Wed, 20 Jan 2010 11:12:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: utrace-devel@redhat.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-Id: <20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
In-Reply-To: <20100119211646.GF16096@redhat.com>
References: <20100119211646.GF16096@redhat.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_11_12_20_+1100_fWrEWOHJrIvqzoa."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_11_12_20_+1100_fWrEWOHJrIvqzoa.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frank,

On Tue, 19 Jan 2010 16:16:46 -0500 "Frank Ch. Eigler" <fche@redhat.com> wro=
te:
>
> Having been reviewed a couple of times, and we hope being a good
> candidate for merging next time, please start pulling
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git b=
ranch master

I have added this from today with you and utrace-devel as the contacts.
I have cc'd the wider community on this email so that people are aware
that this has been included.

> This repo contains frequent merges from Linus' tree.  If you'd prefer
> a cleaner rebase-based branch to pull from, we can make one of those too.

For now it is OK, but you might like to ask Linus if he would like it
cleaned up before submission since it seems to have history right back to
2.6.29 and (as you say) lots of merges with his tree.

You should also add a commit with an entry in MAINTAINERS.

[Standard boilerplate]

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

--Signature=_Wed__20_Jan_2010_11_12_20_+1100_fWrEWOHJrIvqzoa.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWSmQACgkQjjKRsyhoI8z0dACghiamq93y+aBfgGObxvAZgMCY
JAUAn2Ed9LZ2hofeAQ+pIJhXOsK7w2NC
=IfOP
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_11_12_20_+1100_fWrEWOHJrIvqzoa.--
