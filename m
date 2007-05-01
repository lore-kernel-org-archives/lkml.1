Return-Path: <linux-kernel-owner+w=401wt.eu-S1031170AbXEALzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031170AbXEALzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031663AbXEALzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:55:12 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:35406 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031170AbXEALyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:54:47 -0400
Subject: Re: VMware, x86_64 and 2.6.21.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Michael Gerdau <mgd@technosis.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705011309450.18504@yvahk01.tjqt.qr>
References: <1177998147.8981.16.camel@nigel.suspend2.net>
	 <200705010924.51590.mgd@technosis.de>
	 <1178004981.8981.27.camel@nigel.suspend2.net>
	 <Pine.LNX.4.61.0705011309450.18504@yvahk01.tjqt.qr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RZc6HEckO6peP1rjrYeD"
Date: Tue, 01 May 2007 21:54:45 +1000
Message-Id: <1178020485.13953.0.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RZc6HEckO6peP1rjrYeD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-01 at 13:10 +0200, Jan Engelhardt wrote:
> On May 1 2007 17:36, Nigel Cunningham wrote:
> >On Tue, 2007-05-01 at 09:24 +0200, Michael Gerdau wrote:
> >> > Does anyone have VMware working on x86_64 with 2.6.21?
> >>=20
> >> VMware server 1.0.2 (free edition) is working fine here with 2.6.21.1
> >> using vmware-any-any-update109.
> >>=20
> >> System is Intel Core2 T7600 (x86_64)
> >
> >Ok. Maybe I'll try the any-any update. I'm using the Workstation 6 beta.
> >Could I get you to send me your .config, just in case?
>=20
> the AA updates are not for WS6 AFAICT (at least this was the case with aa=
105).

Yeah. It turns out that I was still on WS 6 beta 1. Upgrading to beta 2
made the problem go away.

Regards,

Nigel

--=-RZc6HEckO6peP1rjrYeD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGNyqFN0y+n1M3mo0RAj62AKCSt8VPdvRR+WeV9nWPZYRveuswDgCfZD4b
rYQEFXaQ/p+drEtrQ6No3/4=
=E0Xy
-----END PGP SIGNATURE-----

--=-RZc6HEckO6peP1rjrYeD--

