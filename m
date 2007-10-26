Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXJZKrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXJZKrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXJZKrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:47:09 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:54192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXJZKrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:47:08 -0400
Subject: Re: [PATCH 0/6] kernel-doc: add DOC: sections support
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org
In-Reply-To: <20071025192145.GQ19691@waste.org>
References: <11932637282902@xenotime.net> <20071025172932.GN17536@waste.org>
	 <20071025103611.f2ae216f.rdunlap@xenotime.net>
	 <20071025192145.GQ19691@waste.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ysu5vN6/me1Fx+QbeBvo"
Date: Fri, 26 Oct 2007 12:48:17 +0200
Message-Id: <1193395697.4406.56.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ysu5vN6/me1Fx+QbeBvo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > ./drivers/net/3c527.c: * DOC: Notes
>=20
> Aside from those being about the least interesting drivers in the
> tree, that's pretty neat.
>=20
> The docbook infrastructure probably needs to figure out a way to pick
> up this stuff automatically if it's not otherwise tied in.

The 5th and 6th patch in this series do that by allowing you to write

!Pfilename section title

in a docbook template file to insert the contents of such a section.
It's what I'm doing for mac80211's docs so that browsing the files gives
you the same documentation as reading the mac80211 docbook book just
organised differently.

johannes

--=-ysu5vN6/me1Fx+QbeBvo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyHF8KVg1VMiehFYAQL65RAAtIlvF5eUgofitfAxXWDwwTB0Um/K+XWV
XTtKgV7rGo7enYrQFpBafUu/puAOwyGgygTsR2Qu3xwKcAxsgYDkc8FIxuYFGiE7
5tcH6z2pIhnJyPsTqNE5ELgn/JCrQPyjy6co4RCPgOMxryIkZOLS1Lx0ewfAhkHK
4k/9fzKsoM02MrW3fAR6NAnI5HGYRynMoFyFuOXZ/zZfn8k2y25hxrnvpwHAy5iZ
1SD812GjlRj2RCU9XskwyjokyDKBbObotUhIzrrbMvxkVrq7mGXwoV8P9yJSCc/C
1/7UvSOUD2OP7wy0dXRBsP+DIa5wHhNLpfs2tFc4vAYhrYAIpflHe7eRE/1oN+kw
Je+Zp32qO8tNawJDQHVR9zYjYekcsVEfivHuP0Euw9y4jQEZ6glR67AvgoHab+KC
nb6WV3P/TrPyFqsoim6DwlRRsss+9hq7qV08iywIQ47PktbJ1J+jGM7JYRjUUwco
xbIdh8D/PdOfMGifpFj63LLxZa852uf/lQJAMHYdoIxJSA140PrxM+HDir6XxXZp
MWxWgXFyNI+9FN96Vi0B5QsXJBb2onKQTz/quniwhu3WIuhdcaP+3eeHWZdZprbo
n7ZqMguPz3rgOUq/mE+qg+L6x8e8DVBAss6hQrX0HFjWIjM3UtAl8Jz5yjCqiGdZ
PHTMqlJdQFI=
=dZdS
-----END PGP SIGNATURE-----

--=-ysu5vN6/me1Fx+QbeBvo--

