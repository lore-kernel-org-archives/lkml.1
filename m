Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZIQQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZIQQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZIQQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:35:45 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:44373 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZIQQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:35:45 -0400
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
From: Scott James Remnant <scott@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
In-Reply-To: <20090917141303.428fe73c@lxorguk.ukuu.org.uk>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	 <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	 <20090917141303.428fe73c@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zv+tMy1/hBPF6qGZDaNB"
Date: Thu, 17 Sep 2009 17:35:32 +0100
Message-Id: <1253205332.4718.9.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zv+tMy1/hBPF6qGZDaNB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 14:13 +0100, Alan Cox wrote:

> > >  * A static dev is faster.
> >=20
> > A static /dev is unreliable and unpredictable, and can not be used in
> > any not very limited and controlled environment. It's pure theory for
>=20
> Moblin appears to be the fastest boot and doesn't use it. I fact Arjan
> seems pretty anti
>=20
And of the "ordinary" distros, Ubuntu has the fastest boot and we are
very keen to use devtmpfs, and I am very pro.


I don't really see the issue here.  If Arjan doesn't want to use
devtmpfs for Moblin, he doesn't have to.  We want to use devtmpfs for
Ubuntu, and I'm pretty sure that SuSE, Fedora and RedHat all want to too
based on the signed off and tested-by of the patch.

If there are bugs, they can be fixed as we go.  It certainly works for
me, and we've even found udev bugs as a result of it.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-zv+tMy1/hBPF6qGZDaNB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqyZVQACgkQSnQiFMl4yK4G7gCfck+R0TWXqIee3UNdaAQhuDuA
pCoAniU2r9eoK/qXnloe8UyUQcpK/deh
=vAtT
-----END PGP SIGNATURE-----

--=-zv+tMy1/hBPF6qGZDaNB--

