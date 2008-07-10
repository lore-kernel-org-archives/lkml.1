Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYGJRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYGJRew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYGJReo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:34:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:40406 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756157AbYGJRen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:34:43 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18cnuNeZfgc/nKJVsw9kFhFL2jxoWGqxUeTaIq8qY
	FFySaptjwP/Qko
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] UML kernel failed to start betvee 2.6.8-rc8 and current git sources
Date: Thu, 10 Jul 2008 19:34:29 +0200
User-Agent: KMail/1.9.9
References: <200807101619.54052.toralf.foerster@gmx.de> <20080710165811.GA18429@c2.user-mode-linux.org>
In-Reply-To: <20080710165811.GA18429@c2.user-mode-linux.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7463171.7x93uD96zl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807101934.33636.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7463171.7x93uD96zl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Thursday 10 July 2008 18:58:11 Jeff Dike wrote :
> On Thu, Jul 10, 2008 at 04:19:51PM +0200, Toralf F=F6rster wrote:
> > from v2.6.26-rc8 to v2.6.26-rc9-56-g6329d30 sth. affected UML, b/c my u=
ser mode linux kernel produces this :
>=20
> That UML runs fine here.  Did you also upgrade the host kernel between
> rc8 and now?
>=20
Yes, but that's not the reason. The UML crashes both under host kernel
2.6.24-gentoo-r8 and 2.6.25-gentoo-r6. The last (available) working UML ker=
nel
is linux-v2.6.26-rc8-227 (tested under host kernel 2.6.25-gentoo-r6).

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart7463171.7x93uD96zl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkh2SCkACgkQhyrlCH22naMjTwCgqfwm5tDOy6N5qLQ+0NYgnHnD
l/sAoL074J3w1fI1wkVDU7MoRXuxopI+
=07pG
-----END PGP SIGNATURE-----

--nextPart7463171.7x93uD96zl--
