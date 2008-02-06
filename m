Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYBFUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYBFUN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbYBFUNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:13:41 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33086 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756013AbYBFUNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:13:40 -0500
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
	tty_poll
From: Zan Lynx <zlynx@acm.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20080206194442.00a4f96a@core>
References: <1202326722.7488.46.camel@localhost>
	 <20080206194442.00a4f96a@core>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t5f2xhDspnhVVCfFqjpY"
Date: Wed, 06 Feb 2008 13:16:10 -0700
Message-Id: <1202328970.7488.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080206/1JMqeH-0000Yj-PT-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t5f2xhDspnhVVCfFqjpY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-02-06 at 19:44 +0000, Alan Cox wrote:
> On Wed, 06 Feb 2008 12:38:42 -0700
> Zan Lynx <zlynx@acm.org> wrote:
>=20
> > This doesn't happen often so it is rather hard to nail down, but I am
> > fairly sure it didn't happen before I started running the 2.6.24 MM
> > series kernels.
>=20
> Do you have the -mm1 hot fixes applied  if its occuring in 2.6.24-mm1 ?

All of them except stop-c_p_a-corrupting-the-pds.patch but I don't think
that matters since the patch description says it affects x86_32 and this
system is x86_64.
--=20
Zan Lynx <zlynx@acm.org>

--=-t5f2xhDspnhVVCfFqjpY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHqhWKG8fHaOLTWwgRAimvAJ0YaucpsbRs8awzpFs1SSOg5EO2nwCfQ/Vp
vL8lyrbUclNBmYpFVjwqCsE=
=breY
-----END PGP SIGNATURE-----

--=-t5f2xhDspnhVVCfFqjpY--

