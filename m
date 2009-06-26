Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbZFZRYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbZFZRYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZFZRYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:24:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41546 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFZRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:24:34 -0400
Date: Sat, 27 Jun 2009 03:24:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: linux-next: Tree for June 26 (cyclades)
Message-Id: <20090627032430.2c63249a.sfr@canb.auug.org.au>
In-Reply-To: <4A44F18D.2000608@oracle.com>
References: <20090626154605.ac73b738.sfr@canb.auug.org.au>
	<4A44F18D.2000608@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__27_Jun_2009_03_24_30_+1000_IUpvxZ+yFI5qJTLB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__27_Jun_2009_03_24_30_+1000_IUpvxZ+yFI5qJTLB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jun 2009 09:04:29 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> drivers/char/cyclades.c:3332: error: assignment of read-only location
>=20
> (it's const)

Caused by commit 93d671fe9bcceb522c922223f836f9c54873b866
("tty-cyclades-cleanup") from the ttydev tree.

Adding cc's.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__27_Jun_2009_03_24_30_+1000_IUpvxZ+yFI5qJTLB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpFBE4ACgkQjjKRsyhoI8yEMgCeJ1LKhEkvo8tRZhscMfwtcD+G
02YAnjiIGt8LAPK8anyS+EOIsVMiqN04
=Y+/Y
-----END PGP SIGNATURE-----

--Signature=_Sat__27_Jun_2009_03_24_30_+1000_IUpvxZ+yFI5qJTLB--
