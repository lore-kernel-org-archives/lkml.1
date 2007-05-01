Return-Path: <linux-kernel-owner+w=401wt.eu-S1423564AbXEAGdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423564AbXEAGdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031117AbXEAGdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:33:31 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53906 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031109AbXEAGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:33:30 -0400
Subject: Re: VMware, x86_64 and 2.6.21.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
References: <1177998147.8981.16.camel@nigel.suspend2.net>
	 <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fetVFe9Bmfz7hQAJ8w88"
Date: Tue, 01 May 2007 16:33:28 +1000
Message-Id: <1178001208.8981.21.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fetVFe9Bmfz7hQAJ8w88
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-01 at 14:13 +0800, Jeff Chua wrote:
> On 5/1/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > Hi.
> >
> > Does anyone have VMware working on x86_64 with 2.6.21? It's working fin=
e
> > for me with 2.6.20, but freezes the whole computer with 2.6.21. Before =
I
>=20
>=20
> I'm on i386 and noticed it makes the "guest" very unresponsive.
>=20
> Uncheck "disable write-caching" solves the problem.

Thanks for the reply.

x86_64 seems to have a completely different issue. I think something in
the changes that went in for x86 might have broken x86_64 completely.
Guess I'll have to try a bisect.

Regards,

Nigel

--=-fetVFe9Bmfz7hQAJ8w88
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGNt84N0y+n1M3mo0RAtXdAKCFj+Yn4sKmOX1ocp3MASe1/SH63gCgylcL
Aigh4U1F+Rv6iiyy77UOqZo=
=K+y6
-----END PGP SIGNATURE-----

--=-fetVFe9Bmfz7hQAJ8w88--

