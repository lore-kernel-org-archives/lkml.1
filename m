Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXK0XIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXK0XIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXK0XH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:07:59 -0500
Received: from mail.vapor.com ([85.114.133.49]:41711 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXK0XH6 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:07:58 -0500
Subject: [SKY2] Problems (2.6.24-rc3-git1)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linux-kernel <Linux-kernel@vger.kernel.org>
In-Reply-To: <20071002215914.13d1e8cf@freepuppy.rosehill>
References: <1191372129.26233.12.camel@localhost>
	 <20071002180209.47c350a3@freepuppy.rosehill>
	 <1191375274.26233.17.camel@localhost>
	 <20071002215914.13d1e8cf@freepuppy.rosehill>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jAN6gfKGvpqOGSXYURYj"
Date: Wed, 28 Nov 2007 00:07:55 +0100
Message-Id: <1196204875.1616.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jAN6gfKGvpqOGSXYURYj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=46rom lkml:
On Tue, 27 Nov 2007 23:40:22 +0100
Ian Kumlien <pomac@vapor.com> wrote:

> [Repost, no reply has been recived]
>=20
> Hi,
>=20
> A little while ago, something went horribly wrong.
>=20
> I could still use my mouse and the desktop was still alive more or
> less... everything using networking was dead AND the keyboard was
> dead... So i composed commands using existing text on the screen.
>=20
> The device:
> sky2 0000:02:00.0: v1.20 addr 0xdbffc000 irq 17 Yukon-EC (0xb6) rev 2
> sky2 0000:02:00.0: PCI Express Advanced Error Reporting not configured or=
 MMCONFIG problem?
> sky2 0000:02:00.0: No interrupt generated using MSI, switching to INTx mo=
de.
> sky2 eth0: addr 00:15:f2:aa:8b:3e

The recovery logic for hung FIFO no longer works in 2.6.24-rc1+, I'm lookin=
g
into it.
---

Ahh, ok thanks, i dunno if your reply is caught in greylisting...=20
Else please CC always =3D)
(did you get the email on netdev as well? in that case, i'm very sorry
for reposting... I only follow linux-kernel on a regular basis)

When you have something ready for testing, mail me a patch =3D)

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-jAN6gfKGvpqOGSXYURYj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHTKNI7F3Euyc51N8RAsTVAKC7hipDW+H1Y1DfEh60RQ0y176r9gCgrPd4
D9UgTHIrLg2U2WyVzhatrPE=
=mAyw
-----END PGP SIGNATURE-----

--=-jAN6gfKGvpqOGSXYURYj--

