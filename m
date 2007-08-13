Return-Path: <linux-kernel-owner+w=401wt.eu-S940049AbXHMUmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940049AbXHMUmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937598AbXHMUlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:41:44 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33606 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936861AbXHMUll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:41:41 -0400
Subject: Re: How to make -mm a more viable testbed (was: [PATCH] [1/12]
	x86: Work around mmio config space quirk on AMD)
From: Zan Lynx <zlynx@acm.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200708130808.46989.a1426z@gawab.com>
References: <200708130808.46989.a1426z@gawab.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jLenouTJordaWZ+RI3XD"
Date: Mon, 13 Aug 2007 14:40:06 -0600
Message-Id: <1187037607.7855.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20070813/1IKgjI-0002sr-EI-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jLenouTJordaWZ+RI3XD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 08:08 +0300, Al Boldi wrote:
> Linus Torvalds wrote:
> > On Sun, 12 Aug 2007, Dave Jones wrote:
> > >=20
> > > This does make me wonder, why these weren't caught in -mm ?
> >=20
> > I'm worried that -mm isn't getting a lot of exposure these days. People=
 do=20
> > run it, but I wonder how many..
>=20
> Well, I'm not running it because it's got too much garbage in it, which m=
akes=20
> it a pretty unrealistic testbed.  And to make matters worse, I also stay=20
> away from rc's as a consequence.
>=20
> To make -mm more viable, it may be advisable to restructure -mm in such a=
 way=20
> as to be a Kconfig option to mainline.  This would probably involve some=20
> patch management functionality to apply experimental submissions on a=20
> per-patch basis, as opposed to being a 'take it or leave it slam onto=20
> mainline' patch.

I thought most people running -mm were running klive, which shou
ld tell kernel versions, uptime and other things.  I run it, anyway.

http://klive.cpushare.com/
--=20
Zan Lynx <zlynx@acm.org>

--=-jLenouTJordaWZ+RI3XD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGwMGmG8fHaOLTWwgRAn9JAKCYSIN7X2K0+SvMJe+VD2/lJuP8HgCfXjuX
873ZoLRtbzwBJ4QiFSp9fpY=
=F05z
-----END PGP SIGNATURE-----

--=-jLenouTJordaWZ+RI3XD--

