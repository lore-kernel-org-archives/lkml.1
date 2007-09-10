Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXIJLL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXIJLL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXIJLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:11:19 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:46254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXIJLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:11:18 -0400
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches v2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>, netdev@vger.kernel.org,
       Florian Lohoff <flo@rfc822.org>, linux-wireless@vger.kernel.org,
       Martin Langer <martin-langer@gmx.de>, Stefano Brivio <st3@riseup.net>,
       Michael Buesch <mbuesch@freenet.de>,
       Danny van Dyk <kugelfang@gentoo.org>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>
In-Reply-To: <1189422562.4506.56.camel@johannes.berg>
References: <46E28149.2090900@googlemail.com>
	 <46E2836B.60406@googlemail.com>  <1189422562.4506.56.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U8QWb29abg3AZDHR84dm"
Date: Mon, 10 Sep 2007 13:12:42 +0200
Message-Id: <1189422762.4506.60.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U8QWb29abg3AZDHR84dm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 13:09 +0200, Johannes Berg wrote:
> On Sat, 2007-09-08 at 13:11 +0200, Michal Piotrowski wrote:
>=20
> > Subject         : Unable to access memory card reader anymore

> Last known good/caused-by doesn't apply, the bug has been in there ever
> since the mac80211 code was merged into the tree.

Eh, no, I quoted the wrong one by accident,

Subject         : ifconfig eth1 - scheduling while atomic: ifconfig/0x00000=
002/4170

is the one I was thinking of.

johannes

--=-U8QWb29abg3AZDHR84dm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5Saq/ETPhpq3jKURAoMyAJsHjNr9tfXt1zIn3pH0FZDxe1pU+gCgrwj4
zRT4v5XaTYTzyHER0rYGr1A=
=K4j8
-----END PGP SIGNATURE-----

--=-U8QWb29abg3AZDHR84dm--

