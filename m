Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbXFRVuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbXFRVuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764088AbXFRVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:49:55 -0400
Received: from pan.madism.org ([88.191.52.104]:40245 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763953AbXFRVty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:49:54 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 17:49:53 EDT
Date: Mon, 18 Jun 2007 22:27:41 +0100
From: Pierre Habouzit <madcoder@debian.org>
To: Thomas Glanzmann <thomas@glanzmann.de>, carlo@alinoe.com,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
Message-ID: <20070618212741.GA5938@artemis.internal.dc7.debconf.org>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>, carlo@alinoe.com,
	Linus Torvalds <torvalds@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
	GIT <git@vger.kernel.org>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Q68bSM7Ycu6FN28Q";
	protocol="application/pgp-signature"; micalg=SHA1
Content-Disposition: inline
In-Reply-To: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Madmutt/devel (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2007 at 11:25:24PM +0200, Thomas Glanzmann wrote:
> Hello,
> a friend of mine always builds the Debian Packages from unstable for
> Debian Etch. I have on all my machines the following line in
> /etc/apt/sources.list:
>=20
>         deb http://rmdir.de/~michael/git/ ./

  FWIW there is even simpler: I maintain a backport on
www.backports.org. Which is a semi-official service driven by Debian
Developers.

Cheers,
--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGdvjNvGr7W6HudhwRAj6WAJ9ykN43ePDvw0G5T9fvvQh8bMBUAQCeKrQ4
DrfxIN1mc0wDh4RbLwSdyk4=
=vrbt
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
