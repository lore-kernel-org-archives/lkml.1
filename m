Return-Path: <linux-kernel-owner+w=401wt.eu-S935899AbZLPXA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899AbZLPXA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbZLPXAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:00:39 -0500
Received: from gold.linx.net ([195.66.232.40]:42356 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874AbZLPXAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:00:34 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 18:00:33 EST
Subject: Re: [git pull] VFS stuff, part 1
From: Tony Vroon <tony@linx.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
	 <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-89ZE5gIS7BHG0CvdSvvf"
Organization: London Internet Exchange (LINX; AS5459)
Date: Wed, 16 Dec 2009 22:54:08 +0000
Message-ID: <1261004048.3154.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-89ZE5gIS7BHG0CvdSvvf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-17 at 01:41 +0300, Alexander Beregalov wrote:
> mkdir `/lib/rc/init.d/starting': Operation not supported

Confirmed, mkdir fails for any tmpfs filesystem. I can still create
files using touch and remove them again with rm.

Regards,
Tony V.

--=-89ZE5gIS7BHG0CvdSvvf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAkspZQ8ACgkQp5vW4rUFj5r6GACfUs1t71J4LZnZ51w/OwJlG4w5
AOEAoKCdLtvo/h872Z22LqqZq5qFVgjS
=6XFt
-----END PGP SIGNATURE-----

--=-89ZE5gIS7BHG0CvdSvvf--

