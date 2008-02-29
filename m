Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYB2Q5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYB2Q5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933037AbYB2Q44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:56:56 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34203 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932671AbYB2Q4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:56:55 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Zan Lynx <zlynx@acm.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mbatWducwQfd9kfrWbvL"
Date: Fri, 29 Feb 2008 09:59:11 -0700
Message-Id: <1204304352.6767.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080229/1JV8XM-000259-Hi-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mbatWducwQfd9kfrWbvL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 08:08 -0800, Linus Torvalds wrote:
[cut]
> It loads non-GPL code, it is non-GPL.
[cut]
> Exactly. And ndiswrapper loads proprietary modules.

The Linux kernel itself will load proprietary modules.  It does not as a
general rule, but it will.

Is the Linux kernel then not GPL?  No.  This argument doesn't work,
Linus.

There exists at least one GPL NDIS driver[1].  How about if everyone
involved piously promises to load it at least once?

[1] http://cipe-win32.sourceforge.net/
--=20
Zan Lynx <zlynx@acm.org>

--=-mbatWducwQfd9kfrWbvL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHyDnfG8fHaOLTWwgRAiPxAKCn1Psqzna4ZHU/u6CI9q+3qa6TVgCdEyDL
qTwnN2Dd8JB+hLzm7udZjOg=
=FfJY
-----END PGP SIGNATURE-----

--=-mbatWducwQfd9kfrWbvL--

