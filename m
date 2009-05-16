Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZEPJ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZEPJ6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZEPJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:58:12 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:49531 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZEPJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:58:12 -0400
Date: Sat, 16 May 2009 11:58:03 +0200
From: Nico Schottelius <nico-linux-20090330@schottelius.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Nico Schottelius <nico-linux-20090330@schottelius.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: setlocalversion bug [Was: Linux 2.6.30-rc6]
Message-ID: <20090516095803.GA1724@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090330@schottelius.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain> <4A0E62D4.5080004@garzik.org> <20090516084801.GA16044@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20090516084801.GA16044@uranus.ravnborg.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc5-next-20090515-05297-g9bbe396 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg [Sat, May 16, 2009 at 10:48:01AM +0200]:
> On Sat, May 16, 2009 at 02:53:08AM -0400, Jeff Garzik wrote:
> > "2.6.30-rc6-00000-rc6" seems like something is broken, as building a=20
> > released version from git always gave me a proper "2.6.30-rc5"-style=20
> > version, as expected.
>=20
> Hi Nico.
>=20
> This looks like something introduced by:=20
> a182ad3d0f858f50bb719a48bb35a013e12366c5
> ("kbuild: fix scripts/setlocalversion with git")
>=20
> Can you take a look at this.

Sure, I'm just on the way to the train, will send you a fix
this night.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoOjisACgkQuL75KpiFGIxkEACg2VfdrJe2ALfGlMe2lIO+xU8t
/vwAniFgqZJsI0ltUPd2eEgJewb3Fq36
=F/IF
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
