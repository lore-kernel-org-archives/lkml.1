Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZGWH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZGWH0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZGWH0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:26:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38025 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbZGWH0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:26:17 -0400
Date: Thu, 23 Jul 2009 17:25:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-Id: <20090723172559.e7aebbb5.sfr@canb.auug.org.au>
In-Reply-To: <20090722232259.d0ff3495.akpm@linux-foundation.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_17_25_59_+1000__mQ2WJm1INpGKkB."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_17_25_59_+1000__mQ2WJm1INpGKkB.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 22 Jul 2009 23:22:59 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> I actually already have a little pile of MMC things queued:
>=20
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-in-mmc_power_up-use-=
previously-selected-ocr-if-available.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/omap-hsmmc-do-not-enable=
-buffer-ready-interrupt-if-using-dma.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/mmc-msm_sdccc-driver-for=
-htc-dream.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-convert-printk=
kern_level-to-pr_level.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-stylistic-clea=
ning.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/msm_sdccc-move-overly-in=
dented-code-to-separate-function.patch
>=20
> I guess we own them now ;)

So how about, as an experiment, you put all those (at least those that are
"stable") into a git tree (or quilt series) based on Linus' tree and I
could replace the current linux-next mmc tree (which is empty) with that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jul_2009_17_25_59_+1000__mQ2WJm1INpGKkB.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpoEIcACgkQjjKRsyhoI8xOTwCdEC2mphBAwNNPunLawa4aFo6z
mRMAoJKU9Z71wBrQgSVOFPqkvu/t0U2g
=pJ2M
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_17_25_59_+1000__mQ2WJm1INpGKkB.--
