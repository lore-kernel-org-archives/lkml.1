Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbZGQFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbZGQFcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZGQFcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:32:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50585 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZGQFcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:32:50 -0400
Date: Fri, 17 Jul 2009 15:32:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20090717153243.b8392c24.sfr@canb.auug.org.au>
In-Reply-To: <20090717045620.GC17656@kroah.com>
References: <20090717112935.2e831eee.sfr@canb.auug.org.au>
	<20090717045620.GC17656@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jul_2009_15_32_43_+1000_cGiMHPOhjCGCu3tt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jul_2009_15_32_43_+1000_cGiMHPOhjCGCu3tt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 16 Jul 2009 21:56:20 -0700 Greg KH <greg@kroah.com> wrote:
>
> It turned out to be "too late" to make the change, I missed the -rc2
> window, so it will be a .32 thing.
>=20
> I'll move it from my driver-core.current to my driver-core tree to clear
> up any confusion.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jul_2009_15_32_43_+1000_cGiMHPOhjCGCu3tt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpgDPsACgkQjjKRsyhoI8yvgwCglJNLCDzNWnFaEygyH+3QXtJo
J+MAnirdAI625N7qu2NhGsX+d/Ib4vV3
=+ZaV
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jul_2009_15_32_43_+1000_cGiMHPOhjCGCu3tt--
