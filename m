Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYHFGbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYHFGbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYHFGbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:31:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40699 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbYHFGbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:31:33 -0400
Date: Wed, 6 Aug 2008 16:31:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jeremy@xensource.com,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for August 5 (XEN)
Message-Id: <20080806163119.3adc4eb7.sfr@canb.auug.org.au>
In-Reply-To: <4898FB2F.9060202@goop.org>
References: <20080805175914.7649537f.sfr@canb.auug.org.au>
	<20080805180316.b85d5547.randy.dunlap@oracle.com>
	<4898FB2F.9060202@goop.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_16_31_19_+1000_.5RclWQDohRZb8EX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Aug_2008_16_31_19_+1000_.5RclWQDohRZb8EX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Aug 2008 18:15:27 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
> I posted this patch the other day.  It's in tip.git, but I guess it=20
> hasn't made it to next.
>=20
>     J
>=20
> Subject: xen-balloon: fix up sysfs issues

I have applied this to linux-next today - assuming it will turn up via one
of the tip trees soon.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_16_31_19_+1000_.5RclWQDohRZb8EX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiZRTcACgkQjjKRsyhoI8zvAwCfebPiyxolyPe/j4DZ4sS4++wr
XlEAn1ANOIzT7e8RF/P+Wet1FshmI0Bq
=Mcoe
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_16_31_19_+1000_.5RclWQDohRZb8EX--
