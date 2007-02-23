Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbXBWLSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbXBWLSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXBWLSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:18:14 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:58308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbXBWLSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:18:13 -0500
Subject: Re: several messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linuxppc-dev@ozlabs.org,
       rtc-linux@googlegroups.com, linux-pm@lists.osdl.org,
       Torrance <torrance123@gmail.com>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60.0702222352460.6771@poirot.grange>
References: <200702211929.17203.david-b@pacbell.net>
	 <200702211950.22422.david-b@pacbell.net>
	 <Pine.LNX.4.60.0702222352460.6771@poirot.grange>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cDwk91uBwu/qFu5OL5oW"
Date: Fri, 23 Feb 2007 12:17:30 +0100
Message-Id: <1172229450.3870.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cDwk91uBwu/qFu5OL5oW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-22 at 23:58 +0100, Guennadi Liakhovetski wrote:

> I think, we only want 1, right? And the latter seems to be more generic /=
=20
> platform independent? And as a side-effect, powermac would have to migrat=
e=20
> to generic rtc:-)

Can we migrate all of powerpc to genrtc? But yes, I agree. Had enough to
do though already to get suspend working :)

johannes

--=-cDwk91uBwu/qFu5OL5oW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3s1K/ETPhpq3jKURAqBaAKCjpO/qgcV3Np3alMq15nGj5PhYJwCfdoXp
kJ5f8zbUKkdzRtWtwHQOV0Q=
=CzDY
-----END PGP SIGNATURE-----

--=-cDwk91uBwu/qFu5OL5oW--

