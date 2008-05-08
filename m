Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYEHRkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYEHRkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYEHRkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:40:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:60455 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751213AbYEHRkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:40:36 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18Y87ROmSMYXx0nSDirmgYRv3avT/3VOWSL6M13sQ
	UA+Xwvej9tWKy8
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
	device ready test) regression
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Takashi Iwai <tiwai@suse.de>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, sitsofe@yahoo.com
In-Reply-To: <20080508161805.GA3941@gentoox2.trippelsdorf.de>
References: <20080506154847.GA15299@havoc.gtf.org>
	 <20080507145616.GA2210@gentoox2.trippelsdorf.de>
	 <48231DAF.7070900@garzik.org> <s5hhcd83hor.wl%tiwai@suse.de>
	 <20080508161805.GA3941@gentoox2.trippelsdorf.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zqqlaBvoMjTrTj3+GKeY"
Date: Thu, 08 May 2008 19:40:32 +0200
Message-Id: <1210268432.5061.0.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zqqlaBvoMjTrTj3+GKeY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 08.05.2008, 18:18 +0200 schrieb Markus Trippelsdorf:
> On Thu, May 08, 2008 at 06:05:08PM +0200, Takashi Iwai wrote:
> > At Thu, 08 May 2008 11:35:11 -0400,
> > Jeff Garzik wrote:
> > >=20
> > > Markus Trippelsdorf wrote:
> > > >> Tejun Heo (12):
> > > >>       libata: improve post-reset device ready test
> > > >=20
> > > > This commit (78ab88f04f44bed566d51dce0c7cbfeff6449a06) causes a lon=
g
> > > > boot delay with my onboard Promise controller. It seems like libata
> > > > probes for a nonexisting PATA drive...
> > > >=20
> > >=20
> > > Does the attached patch fix things?
> > >=20
> > > It basically reverts the patch, while still maintaining the=20
> > > consolidation.  It looks like that status evaluation is not as univer=
sal=20
> > > as believed.
> >=20
> > Yes, the patch fixes the problem on my machine.
> >=20
>=20
> Your patch fixes the problem for me, too...

me too :)

--=-zqqlaBvoMjTrTj3+GKeY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIIzsQVVCoNUmKuAcRAlvvAJ494nQ2vJyQdg3ab/+1U//U/YOPjACfaoNT
FJa/sSeHV9bTU8nlR8gwCFY=
=wwxw
-----END PGP SIGNATURE-----

--=-zqqlaBvoMjTrTj3+GKeY--

