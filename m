Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbXD3Oy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbXD3Oy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXD3Oy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:54:57 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbXD3Oyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:54:55 -0400
Subject: Re: [PATCH 28/36] Use menuconfig objects II - sound
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
In-Reply-To: <Pine.LNX.4.61.0704301641010.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr>
	 <1177942754.5102.76.camel@johannes.berg>
	 <Pine.LNX.4.61.0704301641010.29151@yvahk01.tjqt.qr>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E4QsjeWPC8WCf70rSGZj"
Date: Mon, 30 Apr 2007 16:55:31 +0200
Message-Id: <1177944931.5102.91.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E4QsjeWPC8WCf70rSGZj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-30 at 16:45 +0200, Jan Engelhardt wrote:

> >+config SND_AOA_CORE
> >+	tristate
>=20
> Why the extra AOA_CORE? Are there some options that require only AOA
> but not AOA_CORE?

Oh, I did the extra AOA_CORE so that AOA doesn't affect the build at all
and because it's useless to build the core module without any of the
codecs or busses.

johannes

--=-E4QsjeWPC8WCf70rSGZj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGNgNj/ETPhpq3jKURAi33AJ45rDoEsJJypUuQ8SmlHnHcDI9TsQCgrM/g
eP1x9IlnGGeu4oX3j3KFs+w=
=Kz7v
-----END PGP SIGNATURE-----

--=-E4QsjeWPC8WCf70rSGZj--

