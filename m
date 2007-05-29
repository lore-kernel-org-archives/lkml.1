Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbXE2Qw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbXE2Qw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXE2QwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:52:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41700 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbXE2QwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:52:04 -0400
X-Sasl-enc: kSj0u48mv+tpvAFBri7zYS4udePRMScGc7JgoyfRrHfZ 1180457523
Message-ID: <465C5AF9.20601@imap.cc>
Date: Tue, 29 May 2007 18:55:21 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>	<46585953.80200@imap.cc>	<20070526090117.dda72286.akpm@linux-foundation.org>	<465A033C.3070400@imap.cc>	<3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com> <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86E9074C50BC3FD27374F558"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86E9074C50BC3FD27374F558
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 29.05.2007 09:25 schrieb Cornelia Huck:
> Could those folks that had trouble with this kernel check out whether
> the following patch helps?

Yes, that patch fixes my problem.

Thanks,
Tilman

> From: Cornelia Huck <cornelia.huck@de.ibm.com>
>=20
> Fix check when to create certain symlinks (the device link and some
> compatible links).
>=20
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>=20
[...]

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig86E9074C50BC3FD27374F558
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGXFsDMdB4Whm86/kRArkmAJ0Z5u5rrp2Tvt+9XvDB5icYJR4YLQCfXk96
rgQNpezkLp8HuBLziQt2tbA=
=K4FE
-----END PGP SIGNATURE-----

--------------enig86E9074C50BC3FD27374F558--
