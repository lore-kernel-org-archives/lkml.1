Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXIGTUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXIGTUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXIGTTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:19:52 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:37879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXIGTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:19:51 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: paulmck@linux.vnet.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
       satyam@infradead.org, flo@rfc822.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, ipw3945-devel@lists.sourceforge.net,
       yi.zhu@intel.com, flamingice@sourmilk.net
In-Reply-To: <200709071801.34909.mb@bu3sch.de>
References: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au>
	 <20070906154612.GD8030@linux.vnet.ibm.com>
	 <1189171635.28781.134.camel@johannes.berg>
	 <200709071801.34909.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qm8tG29p0YzHqNLT+RI2"
Date: Fri, 07 Sep 2007 21:17:50 +0200
Message-Id: <1189192671.28781.191.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qm8tG29p0YzHqNLT+RI2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 18:01 +0200, Michael Buesch wrote:

> What's the problem with trying to lock it?

I think I had a problem with it once when I inserted it into some code
that was atomic and it all blew up badly ;) Nothing important really but
it sort of made me not like it much.

johannes

--=-qm8tG29p0YzHqNLT+RI2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4aPe/ETPhpq3jKURAjYfAJ9HadGEto39HmJSGYkB5drHHTJMnQCeIkoW
b3tas7IMlLzntMI/l/eOg/I=
=9P2b
-----END PGP SIGNATURE-----

--=-qm8tG29p0YzHqNLT+RI2--

