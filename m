Return-Path: <linux-kernel-owner+w=401wt.eu-S1030553AbXAaVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030553AbXAaVqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAaVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:46:51 -0500
Received: from lug-owl.de ([195.71.106.12]:38546 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030553AbXAaVqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:46:50 -0500
Date: Wed, 31 Jan 2007 22:46:48 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Message-ID: <20070131214648.GS5599@lug-owl.de>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@suse.de>,
	Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
	linux-kernel@vger.kernel.org
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de> <20070131172410.GV3754@stusta.de> <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+FGODhbLwgAeSOU"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--u+FGODhbLwgAeSOU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-01-31 19:24:54 +0100, Jan Engelhardt <jengelh@linux01.gwdg.de>=
 wrote:
> How much different hardware does the (old)floppy.c do? I imagine that
> today, where floppies phase out, there will be, in descending order:
>=20
>  * USB floppy drives (atm handled by sd.c, could be better to have sf.c)
>  * FDCs on mainboards
>  * 1.44M drives
>  * 1.2M drives
>=20
> Even a working 2.88M, as cool as it sounds, never landed in my hands ever
> since I've been into computing. Perhaps the oldest, smallest disk I once

I do own a machine that has one :)  Those original IBM PS/2 machines
had them.

On the other hand, Linux' floppy.c could do a bit better to help
archiveing some of the scurrile floppy formats. There is at least one
floppy imaging project to store floppy images for uncommon formats. It
would be nice it the Linux driver could handle something like that...

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:         Alles wird gut! ...und heute wirds schon ein bi=C3=9F=
chen besser.
the second  :

--u+FGODhbLwgAeSOU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFwQ5IHb1edYOZ4bsRAl0bAJ0W3lZ0rRq1GdtzmD5Wg7DqTtJJrQCfUELd
7aqFMgYZ1YU2E2q8p/bHSbo=
=pbW6
-----END PGP SIGNATURE-----

--u+FGODhbLwgAeSOU--
