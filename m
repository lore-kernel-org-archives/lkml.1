Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbXHBOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbXHBOh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXHBOhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:37:19 -0400
Received: from users.crfreenet.org ([81.92.145.1]:32835 "EHLO
	mail.crfreenet.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750815AbXHBOhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:37:17 -0400
Date: Thu, 2 Aug 2007 16:37:12 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
Message-ID: <20070802143712.GA19346@localhost.localdomain>
References: <200708021056.l72Au722008603@wildsau.enemy.org> <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr> <46B1D46D.7080609@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021526310.24572@fbirervta.pbzchgretzou.qr> <46B1DDED.8010703@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <46B1DDED.8010703@msgid.tls.msk.ru>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2007 at 05:36:45PM +0400, Michael Tokarev wrote:
> not become required (it is slowly becoming - for example, some
> packages on Debian (like xen for example) now explicitly depends
> on udev - but so far  I managed to satisfy this dependency by
> other means).

udev is not problem - problem si crazy default configuration
of udev used by some distros. If you use udev with simple sane
configuration, then it just creates device nodes based on kernel
names.

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@=
njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkax7BgACgkQw1GB2RHercMRfACgiEh40s23/Eu5eS6TtQo8mxNf
ikYAn1kSUpElpiaR9CCT5ejGMRPV60vZ
=39MP
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
