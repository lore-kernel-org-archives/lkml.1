Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXD1VSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXD1VSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXD1VSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:18:48 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:35051 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753170AbXD1VSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:18:47 -0400
Subject: Re: [-mm patch] i386: enable 4k stacks by default
From: Zan Lynx <zlynx@acm.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070428191927.GN3468@stusta.de>
References: <20070428191927.GN3468@stusta.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RqRzw2E52tiTwa0VW0qg"
Date: Sat, 28 Apr 2007 15:18:38 -0600
Message-Id: <1177795118.7828.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RqRzw2E52tiTwa0VW0qg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> 4k stacks have become a well-tested feature used fore a long time in
> Fedora and even in RHEL 4.

So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
DM mirror?

Our 32-bit Fedora Core 5 dual Opteron server at work crashed once a week
while running rdiff-backup off a snapshot.  Installing a 64-bit kernel
stopped the crashes, and I believe the 64-bit still uses the bigger
stacks.
--=20
Zan Lynx <zlynx@acm.org>

--=-RqRzw2E52tiTwa0VW0qg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGM7ouG8fHaOLTWwgRAkdGAJ4wVNF8Wb9eerADDoylFgXjtSsThgCfRJnE
7vfVLjoUcbQGVAW+z6es9tQ=
=Lg1x
-----END PGP SIGNATURE-----

--=-RqRzw2E52tiTwa0VW0qg--

