Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZI0C7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZI0C7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 22:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZI0C7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 22:59:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35284 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZI0C7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 22:59:48 -0400
Date: Sun, 27 Sep 2009 12:59:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Philipp Reisner <philipp.reisner@linbit.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       <drbd-dev@linbit.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] linux-next: 20090926 - drop autoconf.h from DRBD driver
Message-Id: <20090927125943.50971de2.sfr@canb.auug.org.au>
In-Reply-To: <20090927125331.5367db08.sfr@canb.auug.org.au>
References: <20090926152800.a6568e53.sfr@canb.auug.org.au>
	<20090926173143.GA5041@linux.vnet.ibm.com>
	<20090926200839.GA5220@merkur.ravnborg.org>
	<20090927125331.5367db08.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__27_Sep_2009_12_59_43_+1000_FZvg4XsJq/wFUs_t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__27_Sep_2009_12_59_43_+1000_FZvg4XsJq/wFUs_t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Sep 2009 12:53:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> So for Greg and Philipp, Sam has added a patch that moves autoconf.h.
> There is no need to include it anywhere anyway, so the above files need
> cleaning up.  I have appended Kamalesh's patch below.  Greg, you may have
> to write your own :-)

I should read the patch :-).  Greg, obviously Kamalesh's patch hits the
staging files as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__27_Sep_2009_12_59_43_+1000_FZvg4XsJq/wFUs_t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq+1R8ACgkQjjKRsyhoI8z3uQCdGAPXCs4h76k/KwjwSSFrymFo
/5cAn3fGlGDtV+xFIIhGli5JAdffcA8F
=N1i5
-----END PGP SIGNATURE-----

--Signature=_Sun__27_Sep_2009_12_59_43_+1000_FZvg4XsJq/wFUs_t--
