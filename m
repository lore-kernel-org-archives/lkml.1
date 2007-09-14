Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXINJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXINJ7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbXINJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:59:41 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3176 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbXINJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:59:40 -0400
Message-ID: <46EA5B6D.6020702@imap.cc>
Date: Fri, 14 Sep 2007 11:59:09 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Robert P. J. Day" <rpjday@mindspring.com>, Chris Wedgwood <cw@f00f.org>,
       LKML <linux-kernel@vger.kernel.org>, davej@redhat.com,
       Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <Pine.LNX.4.64.0709131435001.6921@localhost.localdomain> <20070913192646.GE27146@uranus.ravnborg.org>
In-Reply-To: <20070913192646.GE27146@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig08911949CDB97AD559C29DFB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig08911949CDB97AD559C29DFB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg schrieb:
> On Thu, Sep 13, 2007 at 02:37:11PM -0400, Robert P. J. Day wrote:
>>=20
>> what about "devel-pkg" instead?  that would match fedora's
>> "kernel-devel" naming convention.
>=20
> Does
> make devel-pkg
> in the kernel make you think:
> "This is a minimum package to build an external module".
>=20
> I guess not.

=46rom an rpm-based distribution background, it does, actually.
You typically have to install a "xyzzy-devel" package before
you can compile something related to "xyzzy", so it is quite
natural to look for a "kernel-devel" package providing
whatever is necessary to build kernel modules; and
"cd kernel ; make devel-pkg" reads almost literally like
"make kernel-devel.rpm".

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig08911949CDB97AD559C29DFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG6lt2Q3+did9BuFsRAp3hAJ9tDTlF0n+eUv6ZV2eE2TZAM5pU3ACfTfM7
bangTx+/Rv9uGH/YLQReeLg=
=yj27
-----END PGP SIGNATURE-----

--------------enig08911949CDB97AD559C29DFB--
