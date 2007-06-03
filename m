Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbXFCTRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbXFCTRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 15:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXFCTRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 15:17:48 -0400
Received: from lug-owl.de ([195.71.106.12]:35889 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXFCTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 15:17:47 -0400
Date: Sun, 3 Jun 2007 21:17:44 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: LogFS take four
Message-ID: <20070603191744.GU2649@lug-owl.de>
Mail-Followup-To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org, akpm@osdl.org,
	Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Jamie Lokier <jamie@shareable.org>,
	Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
	Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
	Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Bill Davidsen <davidsen@tmr.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Albert Cahalan <acahalan@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Roland Dreier <rdreier@cisco.com>,
	Ondrej Zajicek <santiago@crfreenet.org>,
	Ulisses Furquim <ulissesf@gmail.com>
References: <20070603183845.GA8952@lazybastard.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R10gueRtU1pFqy+X"
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--R10gueRtU1pFqy+X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-03 20:38:46 +0200, J=C3=B6rn Engel <joern@lazybastard.org> =
wrote:
> This round the patch is split into file-sized hunks.  There actually
> seem to be kernel developers not manly enough to digest 6000+ lines of
> code at once.  An I thought I was the only wimp around.

Though it would be nice to have them as a pile of patches so that
after applying them one-by-one, the kernel still compiles.

Eg. if the first patches wire up the new feature into the build
system, but the actual .c file aren't yet there, that won't compile
and thus make git-bisect'ing harder...

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:         Alles wird gut! ...und heute wirds schon ein bi=C3=9F=
chen besser.
the second  :

--R10gueRtU1pFqy+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGYxPYHb1edYOZ4bsRAuYEAJ4wyb55K7xjMA756Zgks2UoX7uoBgCeJ1O8
CbO2o3g+2MscPNvsEeteFwQ=
=O4MV
-----END PGP SIGNATURE-----

--R10gueRtU1pFqy+X--
