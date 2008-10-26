Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYJZAEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYJZAEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYJZADy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:03:54 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52210 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYJZADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:03:53 -0400
Date: Sat, 25 Oct 2008 20:03:43 -0400
From: "Michael B. Trausch" <mike@trausch.us>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer derefence since 2.6.27 in (e)poll
Message-ID: <20081025200343.08dc7999@zest>
In-Reply-To: <fa.OzlOaDLw1wzOiIOE3c5y1CNHYtk@ifi.uio.no>
References: <fa.tyZSmpETPCXhUoPJmJ8KenIDR9A@ifi.uio.no>
	<fa.LCxpt1ZiVhg13wi1ociM3pxlA5Y@ifi.uio.no>
	<fa.OzlOaDLw1wzOiIOE3c5y1CNHYtk@ifi.uio.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wxqRVD.dYcTx9N7UiOtEd9f";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wxqRVD.dYcTx9N7UiOtEd9f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Oct 2008 12:48:00 UTC
Hugh Dickins <hugh@veritas.com> wrote:
>=20
> Isn't it the issue fixed by
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D122428548613067&w=3D2
>=20

Is there a reason that this patch has not yet been applied to the Linux
kernel?  I just found this thread and had to apply this patch to
2.6.28-rc1.

Shouldn't it go into 2.6.28?

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/wxqRVD.dYcTx9N7UiOtEd9f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkDs98ACgkQ0kE/IBnFmjBetgCcCLASeDvV2mOkhOWxhKLSn8N6
b3wAniAJjQKVHQ/XZAOcZBQ7bcCIWc40
=pt6b
-----END PGP SIGNATURE-----

--Sig_/wxqRVD.dYcTx9N7UiOtEd9f--
