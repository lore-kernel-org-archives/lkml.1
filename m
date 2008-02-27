Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbYB0XGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbYB0XGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760077AbYB0XGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:06:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38075 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759646AbYB0XGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:06:21 -0500
Date: Thu, 28 Feb 2008 10:06:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 27
Message-Id: <20080228100618.3eb58692.sfr@canb.auug.org.au>
In-Reply-To: <20080227195525.GC8840@mit.edu>
References: <20080227170300.25c50fe3.sfr@canb.auug.org.au>
	<20080226230059.58cf3cfa.akpm@linux-foundation.org>
	<20080228010626.fd4e00d2.sfr@canb.auug.org.au>
	<20080227195525.GC8840@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Feb_2008_10_06_18_+1100_WMHV4psAVYVbLm7="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Feb_2008_10_06_18_+1100_WMHV4psAVYVbLm7=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Wed, 27 Feb 2008 14:55:25 -0500 Theodore Tso <tytso@MIT.EDU> wrote:
>
> please add:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git  next

Added, thanks.

> This contains a subset of the patches in the ext4 patch set which we
> are explicitly planning on pushing to Linus at the next merge window.

That's what we want.

> It actually probably wouldn't hurt to pull the entire quilt series
> into linux-next, since we don't export any interfaces that are used by
> other linux trees, and that would give us better heads up for
> conflicts in patches still in development conflicting with upcoming
> core changes.  But it conflicts with the initial premise of
> linux-next, so that's why I set up the next branch of the above git
> tree.

Thanks, the less conflicts I have to fix the better.  :-)  I guess over
time patches will migrate into your next branch or they will appear there
after the next Linus release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Feb_2008_10_06_18_+1100_WMHV4psAVYVbLm7=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxezuTgG2atn1QN8RAszvAJ4xVYJ3clgTHuTVTh9SPdElm/GCqgCdEEAR
JLxrPjXWYnO3pR0toq47fMk=
=XVxl
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Feb_2008_10_06_18_+1100_WMHV4psAVYVbLm7=--
