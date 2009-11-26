Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZKZWeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZKZWeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZKZWeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:34:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41134 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZKZWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:34:07 -0500
Date: Fri, 27 Nov 2009 09:34:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       tj@kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de
Subject: Re: [PATCH] ASoC: tlv320dac33: Change RT wq to singlethread wq
Message-Id: <20091127093407.4c58ee0b.sfr@canb.auug.org.au>
In-Reply-To: <20091126154746.GA10674@rakim.wolfsonmicro.main>
References: <1259236511-25805-1-git-send-email-peter.ujfalusi@nokia.com>
	<20091126154746.GA10674@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_09_34_07_+1100_90F3il4Pqwr6EKSy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_09_34_07_+1100_90F3il4Pqwr6EKSy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark, Peter,

On Thu, 26 Nov 2009 15:47:46 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, Nov 26, 2009 at 01:55:11PM +0200, Peter Ujfalusi wrote:
> > RT workqueue is going away in the near future, replace it with
> > singlethread wq for now, which is still supported.
> >=20
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
>=20
> Applied, thanks.

Thanks guys.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Nov_2009_09_34_07_+1100_90F3il4Pqwr6EKSy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksPAl8ACgkQjjKRsyhoI8yC6gCfU1/r5DS/rfuiTu4X0k13y6N9
JVYAmQEBXhBwmbHnd4y5JX4QkWHHmnsC
=xr7m
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_09_34_07_+1100_90F3il4Pqwr6EKSy--
