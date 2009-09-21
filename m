Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZIUTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZIUTeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZIUTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:34:19 -0400
Received: from gold.linx.net ([195.66.232.40]:48693 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZIUTeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:34:19 -0400
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
From: Tony Vroon <tony@linx.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
In-Reply-To: <4AB7D349.4000802@zytor.com>
References: <1253560490.2934.42.camel@localhost>
	 <4AB7D349.4000802@zytor.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-91B3RnZIIjITUCrB5szs"
Organization: London Internet Exchange (LINX; AS5459)
Date: Mon, 21 Sep 2009 20:35:49 +0100
Message-Id: <1253561749.2934.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-91B3RnZIIjITUCrB5szs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 12:26 -0700, H. Peter Anvin wrote:
> Could you please do a git bisect on this problem?

Would love to, but how do I convert g99bc470 to a correct git revision
number please?

chainsaw@prometheus /cvs/linux-2.6 $ git bisect start
chainsaw@prometheus /cvs/linux-2.6 $ git bisect bad
chainsaw@prometheus /cvs/linux-2.6 $ git bisect good g99bc470
fatal: Needed a single revision
Bad rev input: g99bc470

> 	-hpa

Regards,
Tony V.

--=-91B3RnZIIjITUCrB5szs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkq31ZUACgkQp5vW4rUFj5onpwCeJjn2zFtbVcxKe5GMwMQHhXn4
fUIAni00wQphWZK76izYb+FGyK5C3FRn
=FK4V
-----END PGP SIGNATURE-----

--=-91B3RnZIIjITUCrB5szs--

