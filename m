Return-Path: <linux-kernel-owner+w=401wt.eu-S1762960AbZLQABj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960AbZLQABj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZLQABh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:01:37 -0500
Received: from gold.linx.net ([195.66.232.40]:58580 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZLQABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:01:37 -0500
Subject: Re: [git pull] VFS stuff, part 1
From: Tony Vroon <tony@linx.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091216232729.GO14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
	 <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
	 <1261004048.3154.2.camel@localhost>
	 <20091216230711.GN14381@ZenIV.linux.org.uk>
	 <1261005194.3154.4.camel@localhost>
	 <20091216232729.GO14381@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-g9Ms8W/SgUZH4APcK34u"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 17 Dec 2009 00:02:11 +0000
Message-ID: <1261008131.3026.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g9Ms8W/SgUZH4APcK34u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-16 at 23:27 +0000, Al Viro wrote:
> > Do you want me to revert 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1
> > locally or try linux-2.6 old enough not to have this?
> The former.

That resolves the issue completely. I am now able to boot.

Regards,
Tony V.

--=-g9Ms8W/SgUZH4APcK34u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAkspdQMACgkQp5vW4rUFj5rLNwCfZ3+PpxUl0m6f8/uB1F7vQusf
YIcAn2IpKfJGfD4sJl+0g6SxcIrsvANq
=PcAl
-----END PGP SIGNATURE-----

--=-g9Ms8W/SgUZH4APcK34u--

