Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYEYVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYEYVtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYEYVtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:49:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:36815 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750786AbYEYVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:49:14 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18NW5FZl1YNB6RlLhlW3bGgdTKm/OJgv2tay0TOmD
	BBO/GRWLZq2rcJ
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
From: Mirco Tischler <mt-ml@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20080525210329.GN1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
	 <20080525181118.GG1791@cs181133002.pp.htv.fi>
	 <1211742202.14556.25.camel@mtlp.tischlernetz>
	 <20080525201807.GK1791@cs181133002.pp.htv.fi>
	 <1211749036.16921.16.camel@mtlp.tischlernetz>
	 <20080525210329.GN1791@cs181133002.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WwTRrhhGj3+Zj4HTlmQ8"
Date: Sun, 25 May 2008 23:49:11 +0200
Message-Id: <1211752151.16921.25.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WwTRrhhGj3+Zj4HTlmQ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mo, 2008-05-26 at 00:03 +0300, Adrian Bunk wrote:
> Can you try building without ccache?
>=20
Doesn't help, as expected. Man, I just realised what a great piece of
software ccache is;)
> Can you also try downloading the kernel sources as a tarball from=20
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing ?
Why should I? A fresh checkout of the mainline git-tree in combination with=
 make clean should have the same effect, shouldn't it?(I already did that)
> > Btw: you noticed that this is x86_64 and not i386?
>=20
> I noticed (but I currently only have a 32bit userspace, and for this=20
> kind of error it shouldn't matter).
Ok. I just wanted to make sure it's no difference.
> cu
> Adrian
>=20
Thanks
Mirco

--=-WwTRrhhGj3+Zj4HTlmQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIOd7Xz+diZ7c2xfgRApd3AJ4+B+qIc4L+VEderkOfj69z1V00CwCdEmQd
Z7tnEp5wkhdNzh5c45ViqZA=
=6lqE
-----END PGP SIGNATURE-----

--=-WwTRrhhGj3+Zj4HTlmQ8--

