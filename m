Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYI3LSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYI3LSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYI3LSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:18:22 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:40322 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYI3LSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:18:21 -0400
Subject: Re: CD tray closes spontaneously after opening it
From: Tony Vroon <tony@vroon.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <200809301247.05367.elendil@planet.nl>
References: <200809301247.05367.elendil@planet.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fAjJN/iJv8vDZaaGXu0Y"
Date: Tue, 30 Sep 2008 12:18:11 +0100
Message-Id: <1222773491.4003.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fAjJN/iJv8vDZaaGXu0Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 12:47 +0200, Frans Pop wrote:
> Since 2.6.27 I've had several times, but not always, that after I open th=
e=20
> CD tray by pressing the eject button it spontaneously closes after a=20
> short delay. The delay varies between ~0 and ~2 seconds.

For the record, I had this on my Gentoo system. It turned out that HAL
was responsible. (So it may not be a kernel bug at all)

Do see this report:
http://bugs.gentoo.org/show_bug.cgi?id=3D230886

> Cheers,
> FJP

Regards,
Tony V.

--=-fAjJN/iJv8vDZaaGXu0Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjiCvMACgkQp5vW4rUFj5o2KwCgs+BfJ67MJLlTbmTjNKSBTQaa
hHwAniSFvJXMxXgfxp16r/j/x1IfSNt8
=UUBe
-----END PGP SIGNATURE-----

--=-fAjJN/iJv8vDZaaGXu0Y--

