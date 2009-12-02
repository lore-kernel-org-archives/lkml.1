Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZLBGVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZLBGVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZLBGVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:21:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:45147 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751338AbZLBGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:21:44 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1+idhNJi4KikmESj3/tw3XSr8xGjXeiB0BClKGvJZ
	Jao1TQRkEzyBap
Date: Wed, 2 Dec 2009 19:21:43 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: reiserfs-devel@vger.kernel.org
Cc: edward.shishkin@gmail.com, linux-kernel@vger.kernel.org
Subject: reiser4: newbie help needed?
Message-Id: <20091202192143.48ece851.buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_19_21_43_+1300_CCMdeqhlw2Qydswo"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_19_21_43_+1300_CCMdeqhlw2Qydswo
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I am possibly interested in helping out. Who is currently working on
reiser4? I took a look at the TODO lists, are there any simple tasks to
do for newbies?
Also, where is the latest code development going on?

I also believe that on 'sync', reiser4 currently does absolutely
nothing. The comment in reiser4_sync_inodes says reiser4 does its own
flush elsewhere. Should this be different?

Cheers,
Johannes

--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.

--Signature=_Wed__2_Dec_2009_19_21_43_+1300_CCMdeqhlw2Qydswo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksWB3oACgkQ7X1+MfqVcr3N8QCgld9p16yvIhFXkA56t0JDQ+x6
YaUAniteUAPvMnMZ0f48KlQ+wmOQAozw
=YnnA
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_19_21_43_+1300_CCMdeqhlw2Qydswo--
