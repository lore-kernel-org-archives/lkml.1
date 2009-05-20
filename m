Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZETPAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZETPAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZETO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:59:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46771 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZETO7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:59:55 -0400
Date: Thu, 21 May 2009 00:59:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Wai Yew CHAY <wychay@ctl.creative.com>,
       Ryan RICHARDS <ryan_richards@creativelabs.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20090521005949.a48d8dab.sfr@canb.auug.org.au>
In-Reply-To: <s5hmy977rxm.wl%tiwai@suse.de>
References: <20090521003145.7c31808d.sfr@canb.auug.org.au>
	<s5hmy977rxm.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_May_2009_00_59_49_+1000_=e7sPhrHsADhZlux"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_May_2009_00_59_49_+1000_=e7sPhrHsADhZlux
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Wed, 20 May 2009 16:46:45 +0200 Takashi Iwai <tiwai@suse.de> wrote:
>
> Meanwhile, I'll add Kconfig dependency to x86 so that it won't be
> built on other architectures (which haven't been tested anyway).

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_May_2009_00_59_49_+1000_=e7sPhrHsADhZlux
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoUGuUACgkQjjKRsyhoI8wz7wCgpgtSxBty+Qat2tk2Y6+cN/1K
/hYAn2Wvl1+FbXKBF1yjVALdh/rGCzC8
=K5Ap
-----END PGP SIGNATURE-----

--Signature=_Thu__21_May_2009_00_59_49_+1000_=e7sPhrHsADhZlux--
