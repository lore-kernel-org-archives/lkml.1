Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYBRDQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYBRDQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBRDQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:16:41 -0500
Received: from mx27.mail.ru ([194.67.23.23]:34566 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbYBRDQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:16:40 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.25-rc2] stack trace immediately before rebooting/switching off
Date: Mon, 18 Feb 2008 06:16:31 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200802171516.57468.arvidjaar@mail.ru> <200802171904.54609.rjw@sisk.pl>
In-Reply-To: <200802171904.54609.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1438265.j6jUhYuApx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802180616.36342.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1438265.j6jUhYuApx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 17 February 2008, Rafael J. Wysocki wrote:
> On Sunday, 17 of February 2008, Andrey Borzenkov wrote:
> > In 2.6.25 I get stack trace immediately before system is switched off or
> > reboots. It is too fast to capture it on VGA; netconsole does not captu=
re
> > it either - probably network is already shutdown at this point. I do
> > not have serial port on this system.
> >=20
> > Any idea how could I capture it? Thank you.
> >=20
> > The problem did not exist in 2.6.24 and below.=20
>=20
> Is this the e100 issue you reported later or something else?
>=20

Well, I can't be entirely sure unless I have some way to capture this :)
=20



--nextPart1438265.j6jUhYuApx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAke4+JAACgkQR6LMutpd94zGPQCeImd/1Fy1X2QsgYJWMtGzZWdL
55YAnRWBXoIjB2+Y6jpvCkNYvmFb7iHX
=b39l
-----END PGP SIGNATURE-----

--nextPart1438265.j6jUhYuApx--
