Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZFVAAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZFVAAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZFVAAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:00:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45139 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZFVAAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:00:22 -0400
Date: Mon, 22 Jun 2009 10:00:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
 system is dreadfully slow)
Message-Id: <20090622100021.a40aa1fd.sfr@canb.auug.org.au>
In-Reply-To: <20090621.161343.181101055.davem@davemloft.net>
References: <20090621.141950.160759111.davem@davemloft.net>
	<200906220034.22430.bzolnier@gmail.com>
	<20090621.155756.100422570.davem@davemloft.net>
	<20090621.161343.181101055.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_10_00_21_+1000_19Td.b/dNkovuznj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_10_00_21_+1000_19Td.b/dNkovuznj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, Bart,

On Sun, 21 Jun 2009 16:13:43 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Sun, 21 Jun 2009 15:57:56 -0700 (PDT)
>=20
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Mon, 22 Jun 2009 00:34:22 +0200
> >=20
> >> Lets get over this quickly, since you seem to have such a great
> >> insight into running IDE layer here is a little proposition..
> >>=20
> >> ACK?  [ If not than can we please get back with the program? ]
> >=20
> > Acked-by: David S. Miller <davem@davemloft.net>
>=20
> I've created a new IDE development tree at:
>=20
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git

So, do I immediately switch linux-next to this tree?  The current tree I
am using is empty (relative to Linus' tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_10_00_21_+1000_19Td.b/dNkovuznj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko+yZUACgkQjjKRsyhoI8w7CQCgjgQQUQEj33hNT0BscohtR096
WFoAn05Ps/IetCWk8baWiH89UwotSnak
=uoz/
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_10_00_21_+1000_19Td.b/dNkovuznj--
