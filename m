Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZHPHbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZHPHbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 03:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZHPHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 03:31:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53996 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZHPHbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 03:31:07 -0400
Date: Sun, 16 Aug 2009 17:31:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-mm@kvack.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mm/ipw2200 regression (was: Re: linux-next: Tree for August 6)
Message-Id: <20090816173101.6e47b702.sfr@canb.auug.org.au>
In-Reply-To: <200908151856.48596.bzolnier@gmail.com>
References: <20090806192209.513abec7.sfr@canb.auug.org.au>
	<200908062250.51498.bzolnier@gmail.com>
	<200908071515.45169.bzolnier@gmail.com>
	<200908151856.48596.bzolnier@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__16_Aug_2009_17_31_01_+1000_+6c3MUXKSgOxtZ7o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__16_Aug_2009_17_31_01_+1000_+6c3MUXKSgOxtZ7o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Sat, 15 Aug 2009 18:56:48 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmai=
l.com> wrote:
>
> The bug managed to slip into Linus' tree..
>=20
> ipw2200: Firmware error detected.  Restarting.
> ipw2200/0: page allocation failure. order:6, mode:0x8020
> Pid: 945, comm: ipw2200/0 Not tainted 2.6.31-rc6-dirty #69
                                                   ^^^^^
So, this is rc6 plus what?  (just in case it is relevant).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__16_Aug_2009_17_31_01_+1000_+6c3MUXKSgOxtZ7o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqHtbUACgkQjjKRsyhoI8zhbQCZAVTfcWmZU0Dghmfh3ADZ2kL2
LyQAoLsN7Zd63GWHW1AZKHxsu/q5K43T
=UIR2
-----END PGP SIGNATURE-----

--Signature=_Sun__16_Aug_2009_17_31_01_+1000_+6c3MUXKSgOxtZ7o--
