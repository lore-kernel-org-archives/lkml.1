Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXBORRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXBORRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXBORRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:17:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXBORRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:17:24 -0500
Message-ID: <45D49597.4080105@redhat.com>
Date: Thu, 15 Feb 2007 09:17:11 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] syslets: core code
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE6D6749E18D92F241969FBD7"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE6D6749E18D92F241969FBD7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Linus Torvalds wrote:
> Here's a quick question: how many people have actually ever seen them u=
sed=20
> in "normal code"?=20
>=20
> Yeah. Nobody uses them. They're not all that portable (even within unix=
es=20
> they aren't always there, much less in other places), they are fairly=20
> obscure, and they are just not really easy to use.

That's nonsense.  They are widely used (just hear people scream if
something changes or breaks) and they are available on all Unix
implementations which are not geared towards embedded use.  POSIX makes
AIO in the next revision mandatory.

Just because you don't like it, don't discount it.  Yes, the interface
is not the best.  But this is what you get if you cannot dictate
interfaces to everybody.  You have to make concessions.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigE6D6749E18D92F241969FBD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF1JWX2ijCOnn/RHQRAkCHAJwNZ1GhW+/jtxYkGdrX4oSaZY/Y4ACgyTOn
OSRNeNnBOGB8U9rljJjC5ww=
=tPnt
-----END PGP SIGNATURE-----

--------------enigE6D6749E18D92F241969FBD7--
