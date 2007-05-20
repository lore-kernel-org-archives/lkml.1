Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbXETHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbXETHAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXETHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:00:07 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:44701 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758787AbXETHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:00:05 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Date: Sun, 20 May 2007 08:59:25 +0200
User-Agent: KMail/1.9.5
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
References: <464F57DD.2000309@tmr.com> <200705200812.26391.mgd@technosis.de> <2c0942db0705192330r4004d7bem3556c939c1581553@mail.gmail.com>
In-Reply-To: <2c0942db0705192330r4004d7bem3556c939c1581553@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3301024.7WiUtTQ9nt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705200859.56327.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1179644405;1d0d98c0;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3301024.7WiUtTQ9nt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > I don't want to say the values aren't useful. I simply think there is
> > a high noiselevel.
>=20
> The noise is reflected in the standard deviation he has on those rows.
> The average +- stdev  of one overlaps the average +- stdev of the
> other,

=46or the fairness test on cfs13 this simply is wrong. And for the
test to be stable would require that avg of one is within avg+-stddev
of the other (simple overlap does not suffice).

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart3301024.7WiUtTQ9nt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGT/HsUYYhyuxDQc4RAvDgAJkBjGKmRDIytJjz6AqvyJMV9J+I7wCeMsvY
CBlVG9F74uJ2+8AIG3vxDN0=
=6/kY
-----END PGP SIGNATURE-----

--nextPart3301024.7WiUtTQ9nt--
