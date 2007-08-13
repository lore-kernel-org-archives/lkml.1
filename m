Return-Path: <linux-kernel-owner+w=401wt.eu-S934985AbXHMXHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbXHMXHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbXHMXHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:07:31 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33660 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751608AbXHMXH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:07:28 -0400
Subject: Re: How to make -mm a more viable testbed (was: [PATCH] [1/12]
	x86: Work around mmio config space quirk on AMD)
From: Zan Lynx <zlynx@acm.org>
To: Dave Jones <davej@redhat.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070813210956.GA18334@redhat.com>
References: <200708130808.46989.a1426z@gawab.com>
	 <1187037607.7855.21.camel@localhost>  <20070813210956.GA18334@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tXvhbLjkb/zgEAZiHd5h"
Date: Mon, 13 Aug 2007 17:07:23 -0600
Message-Id: <1187046443.7855.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20070813/1IKj0P-0003vV-Fi-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tXvhbLjkb/zgEAZiHd5h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 17:09 -0400, Dave Jones wrote:
> On Mon, Aug 13, 2007 at 02:40:06PM -0600, Zan Lynx wrote:
>  > I thought most people running -mm were running klive, which shou
>  > ld tell kernel versions, uptime and other things.  I run it, anyway.
>  >=20
>  > http://klive.cpushare.com/
>=20
> If that's the case, there are 3 people running 2.6.23-rc2-mm2.
> I suspect the actual number of users is considerably higher.
> Somehow I doubt that 'most' people are running klive.

I had thought Andrew asked people to do it at one point.  Could have
been someone else, I suppose.  Ah, it was Andrea Arcangeli.

At the time, it seemed more people were doing it.  I guess not though.
Or there really aren't many people running the latest -mm.  It *is*
quite a hassle.  I only do it because I'm crazy. :)

I think klive is a good idea for tracking kernel testing.  Perhaps
mentioning it here again will get more people running it.

I suppose that someone could try to estimate usage by counting patch
downloads off kernel.org.
--=20
Zan Lynx <zlynx@acm.org>

--=-tXvhbLjkb/zgEAZiHd5h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGwOQrG8fHaOLTWwgRAttOAKCFPhE399GxmuiWkiyJSIODWIK/CQCfS0df
m8/uq1duDAm3LO0b2w5SCeQ=
=5QFL
-----END PGP SIGNATURE-----

--=-tXvhbLjkb/zgEAZiHd5h--

