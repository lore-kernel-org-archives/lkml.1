Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZDNK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZDNK1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZDNK1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:27:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50338 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNK1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:27:05 -0400
Date: Tue, 14 Apr 2009 20:26:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next: origin tree build failure
Message-Id: <20090414202657.8f355e7c.sfr@canb.auug.org.au>
In-Reply-To: <20090414.020818.174886786.davem@davemloft.net>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
	<20090414.020818.174886786.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Apr_2009_20_26_57_+1000_ZKI.WXkSg6wDe5H4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Apr_2009_20_26_57_+1000_ZKI.WXkSg6wDe5H4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 14 Apr 2009 02:08:18 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 14 Apr 2009 14:43:17 +1000
>=20
> > sparc: asm/atomic.h on 32bit should include asm/system.h for xchg
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> Just in case it wasn't clear, I'm applying this :)

Ah, ok, thanks :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Apr_2009_20_26_57_+1000_ZKI.WXkSg6wDe5H4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknkZPEACgkQjjKRsyhoI8yF+QCgv4DXdMBFD3Djv1AMiWRbqre9
CUkAnA0zm/YGWjVIv3zdBTahhEtJlOqx
=+hIc
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Apr_2009_20_26_57_+1000_ZKI.WXkSg6wDe5H4--
