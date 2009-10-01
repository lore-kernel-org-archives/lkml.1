Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZJAKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZJAKcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZJAKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:32:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbZJAKb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:31:59 -0400
Date: Thu, 1 Oct 2009 20:31:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20091001203152.f40330a8.sfr@canb.auug.org.au>
In-Reply-To: <s5hljjvk3xn.wl%tiwai@suse.de>
References: <20091001111935.8fb15d90.sfr@canb.auug.org.au>
	<s5hljjvk3xn.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Oct_2009_20_31_52_+1000_lmjDKOorkxsSxrzT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Oct_2009_20_31_52_+1000_lmjDKOorkxsSxrzT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Oct 2009 08:45:40 +0200 Takashi Iwai <tiwai@suse.de> wrote:
>=20
> I overlooked this since SPI was disabled on my test build.
> Now fixed in sound git tree.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Oct_2009_20_31_52_+1000_lmjDKOorkxsSxrzT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrEhRgACgkQjjKRsyhoI8wbgwCdF3go02sPNZJywIVLXrXyfJAL
SSgAmwYjy0Lpa1jeNxs2s1C5T2D6769X
=xOCx
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Oct_2009_20_31_52_+1000_lmjDKOorkxsSxrzT--
