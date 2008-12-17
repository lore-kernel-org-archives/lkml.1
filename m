Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756889AbYLQBml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYLQBml (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYLQBma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:42:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYLQBm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:42:29 -0500
Date: Wed, 17 Dec 2008 12:42:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [RFC] remove linux/hardirq.h from asm-generic/local.h
Message-Id: <20081217124214.3033bdf3.sfr@canb.auug.org.au>
In-Reply-To: <20081214195116.GB11223@flint.arm.linux.org.uk>
References: <20081214133941.GA18035@flint.arm.linux.org.uk>
	<20081214095803.9d16e85f.akpm@linux-foundation.org>
	<20081214195116.GB11223@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Dec_2008_12_42_14_+1100_OCr=2B99n1avZvRO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Dec_2008_12_42_14_+1100_OCr=2B99n1avZvRO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Sun, 14 Dec 2008 19:51:16 +0000 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> Thanks, I've committed to my git tree the addition of linux/hardirq.h to
> those two files I mentioned above.  I guess at some point you'll pick
> those up to prevent build errors on ARM?

Andrew will (presumably) get these through linux-next (which he bases the
mm trees on).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Dec_2008_12_42_14_+1100_OCr=2B99n1avZvRO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklIWPYACgkQjjKRsyhoI8ybpwCfZJ18zseEcWO3ZBreAD7LPOZJ
CScAoIWXRk/sy0GH4aIBi7L6uqahbtrv
=djXG
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Dec_2008_12_42_14_+1100_OCr=2B99n1avZvRO--
