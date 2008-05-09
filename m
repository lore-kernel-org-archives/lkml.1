Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYEIFJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYEIFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYEIFJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:09:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:33997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755479AbYEIFJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:09:42 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18iHrESzg8iMs6wRageK42qyv8WmpMuvGnUyTu0EF
	CVTwRoXMZGq3Hv
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
	device ready test) regression
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Markus Trippelsdorf <markus@trippelsdorf.de>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, sitsofe@yahoo.com
In-Reply-To: <4823BD8E.40109@gmail.com>
References: <20080506154847.GA15299@havoc.gtf.org>
	 <20080507145616.GA2210@gentoox2.trippelsdorf.de>
	 <48231DAF.7070900@garzik.org>  <4823BD8E.40109@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lLsJx3JZ7NRVaKJRz0vS"
Date: Fri, 09 May 2008 07:09:38 +0200
Message-Id: <1210309778.4778.3.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lLsJx3JZ7NRVaKJRz0vS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 09.05.2008, 11:57 +0900 schrieb Tejun Heo:
>=20
> Markus, Alexey, Marc, which controllers are you using?
>=20
> Thanks.
>=20

This is lspci of my controller.

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
SATA IDE Controller (rev 01)

complete lspci -vvxxn you can find here
http://bugzilla.kernel.org/show_bug.cgi?id=3D10619

--=-lLsJx3JZ7NRVaKJRz0vS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBII9ySVVCoNUmKuAcRAn8DAJ4iqGkblpVNQbrVBYzgGegApbbUdwCfdC2x
Yi79t/2w0oKYMr9jYnxVCQw=
=MpOi
-----END PGP SIGNATURE-----

--=-lLsJx3JZ7NRVaKJRz0vS--

