Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZIGHbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZIGHbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZIGHbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:31:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36811 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZIGHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:31:17 -0400
Date: Mon, 7 Sep 2009 17:31:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: slab tree build failure
Message-Id: <20090907173108.3c0148d7.sfr@canb.auug.org.au>
In-Reply-To: <84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
References: <20090907153723.0c984c83.sfr@canb.auug.org.au>
	<84144f020909062310u37ecdddfw31c6cc9a22ccabd9@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_17_31_08_+1000_XQrxa/LxHHLJwMWj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_17_31_08_+1000_XQrxa/LxHHLJwMWj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pekka,

On Mon, 7 Sep 2009 09:10:18 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wro=
te:
>
> AFAICT, you're interested in kmemleak.git, not slab.git. Catalin?

I first got the error after merging the slab tree ... the kmemleak tree
is merged much later.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Sep_2009_17_31_08_+1000_XQrxa/LxHHLJwMWj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqktrwACgkQjjKRsyhoI8ySRQCgk42zmMKddcDGTp856yqyG8f5
XkMAnAooOdMXDzYwCgfnlV4KX6NQZ1+z
=dPZU
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_17_31_08_+1000_XQrxa/LxHHLJwMWj--
