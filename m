Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYEDLte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYEDLte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYEDLtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:49:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:36692 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755144AbYEDLtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:49:23 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1+6N7BnVPa6XysrVxay00UbDGRs/NatYlUe/Gib/t
	/0gFuG5LpjC697
Date: Sun, 4 May 2008 13:49:20 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
Message-ID: <20080504134920.0cdeaa31@highlander.home.lan>
In-Reply-To: <20080504115108.7b5a8e3f@highlander.home.lan>
References: <20080504005209.13af2b2c@highlander.home.lan>
	<20080503231813.GA18248@kroah.com>
	<20080504115108.7b5a8e3f@highlander.home.lan>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CF3UwmcjRTWc7rR0LBrP9f7";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CF3UwmcjRTWc7rR0LBrP9f7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Okay, now it also happened on 2.6.24.6. Same picture, first eth0 (3com
905c) gets into trouble and then the other pci-devices stop working. I
am going to try 2.6.24.5 now ...

--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/CF3UwmcjRTWc7rR0LBrP9f7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHaLA4q3E2oMjYtURAjUTAJ0VwKtUp7/Rq9HFLpdGNO87JRf79wCfYxlv
hdSzTvyJUSaoWpT4vkYz0m8=
=VQOg
-----END PGP SIGNATURE-----

--Sig_/CF3UwmcjRTWc7rR0LBrP9f7--
