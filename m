Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXEOFgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXEOFgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 01:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXEOFgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 01:36:08 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:56046 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057AbXEOFgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 01:36:07 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.22-rc1
Date: Tue, 15 May 2007 07:35:50 +0200
User-Agent: KMail/1.9.5
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4648A3DF.7040004@imap.cc> <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1808731.JI5qUjThgq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705150736.04227.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1179207367;0ce9cd94;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1808731.JI5qUjThgq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> >Seriously, it might be a tad more efficient if the help texts were
> >written by those who invented the options in the first place.
>=20
> menuconfig NETDEV_10000
> 	bool "Ethernet (10GbE)"
> 	---help--
> 	Say Y here to actually be able to go into this menu
> 	and select some drivers that we think belong to the
> 	"10 Gigabit Ethernet" family.
>=20
> 	If unsure, it is unwise to say N!
>=20
> See, this looks so fundamentally basic to me that I find it
> almost funny. YMMV, hence I asked for suggestions from
> other people.

I remember very well the time when I first issued make menuconfig.
Ever since then I've been grateful for all those "fundamentally basic"
explanations. And I've learned quite alot about kernelconfig just
by reading them.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1808731.JI5qUjThgq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGSUbEUYYhyuxDQc4RAqZcAJ9j0RK7eb1hB6jl7NeeOiJPuq0yZgCeN4EX
oPCtURiCrPusvbHa8kXiC2o=
=L9WE
-----END PGP SIGNATURE-----

--nextPart1808731.JI5qUjThgq--
