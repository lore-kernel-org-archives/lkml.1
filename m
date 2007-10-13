Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbXJMHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbXJMHzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXJMHzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:55:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:52145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751967AbXJMHzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:55:41 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/NVgclVrrNDiv+paripuZRdn9RMLvydCYSuos7yF
	+1RcH0ERmhVzMN
Date: Sat, 13 Oct 2007 09:55:36 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange network related data corruption
Message-ID: <20071013095536.32c2afd6@highlander.home.lan>
In-Reply-To: <200710091257.20874.vda.linux@googlemail.com>
References: <20071007184741.3b1951c1@highlander.home.lan>
	<200710081401.32375.vda.linux@googlemail.com>
	<20071009132553.439f7d8b@cp771133>
	<200710091257.20874.vda.linux@googlemail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/t.94BSW/VBnijQ3PVoYr5E0";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t.94BSW/VBnijQ3PVoYr5E0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Oct 2007 12:57:20 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> On Tuesday 09 October 2007 12:25, Malte Schr=C3=B6der wrote:
> > > Does it happen over loopback?
> >=20
> > I just tried a few times and yes, it also happens on loopback, but
> > much less frequently. Now I am really confused ...
>=20
> Actually, that eliminates a lot of cases.
>=20
> Run memtest86 overnight ("bad hardware" theory),

Well, that did not show problems. But I put apart the PC, removed dust
and so on.
Now it doesn't even boot anymore (i.e. no BIOS, not even pcspeaker when
I boot without RAM. So I declare the mainboard as dead.

> try older kernel versions ("kernel bug" theory).

Done. But it is the hardware.


Thanks for the advise :)

> --
> vda
>=20


--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/t.94BSW/VBnijQ3PVoYr5E0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHEHn74q3E2oMjYtURAuuOAJoCI3pFy/DIfkVWFGqDn4OuWEEr2gCfaDOB
4SoUQfe8k52cJPb0yWPSUjA=
=FSh0
-----END PGP SIGNATURE-----

--Sig_/t.94BSW/VBnijQ3PVoYr5E0--
