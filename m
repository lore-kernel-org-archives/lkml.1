Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXFWHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXFWHX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXFWHXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:23:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:33654 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751628AbXFWHXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:23:49 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/uD49Sforug071EyrX5HIMCHbiW7aFF8BcFJTat5
	hv/MiasFn7F/Zh
Date: Sat, 23 Jun 2007 09:23:44 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Stuart Anderson <anderson@ligo.caltech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOPS in 2.6.19.1, connected to nfs4 and autofs4
Message-ID: <20070623092344.31686480@highlander.home.lan>
In-Reply-To: <20070623004236.GA2194@ligo.caltech.edu>
References: <20070623004236.GA2194@ligo.caltech.edu>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_lVKv_n75OEem8K.gLZpL9AK;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_lVKv_n75OEem8K.gLZpL9AK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Jun 2007 17:42:36 -0700
Stuart Anderson <anderson@ligo.caltech.edu> wrote:

(I CC: this to the lkml)

> Did you find a resolution to your posting regarding,
>=20
> "OOPS in 2.6.19.1, connected to nfs4 and autofs4"
>=20
> We just had a 2.6.20.11 kernel crash with a similar stack trace.

No, it still happens (2.6.21.5) once in a while (once in a week or so).
I don't know a way to clearly reproduce this.

>=20
>=20
> Thanks.
>=20


--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_lVKv_n75OEem8K.gLZpL9AK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGfMqA4q3E2oMjYtURAvG5AKCuB6x3j62FWmPaTLQHD+DO2ATMfwCgqsEl
1VTmfr83SXAIebKHHGbtK4o=
=N4Cw
-----END PGP SIGNATURE-----

--Sig_lVKv_n75OEem8K.gLZpL9AK--
