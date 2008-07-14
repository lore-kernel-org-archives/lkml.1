Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYGNPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYGNPWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYGNPWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:22:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34582 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYGNPWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:22:03 -0400
Date: Tue, 15 Jul 2008 01:21:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm tree reorganisation for merge window
Message-Id: <20080715012153.a3bb9df0.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.0.82.0807140147500.9419@skynet.skynet.ie>
References: <alpine.DEB.0.82.0807140147500.9419@skynet.skynet.ie>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Jul_2008_01_21_53_+1000_A9CajdDdysRifjpg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jul_2008_01_21_53_+1000_A9CajdDdysRifjpg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 14 Jul 2008 01:49:15 +0100 (IST) Dave Airlie <airlied@linux.ie> wro=
te:
>
> Please pull the 'drm-reorg' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-=
reorg
>=20
> This contains a moving around of a lot of the DRM into a more Linux like=
=20
> tree and makes it a lot nicer going forward for merging new features.

Does this tree have a fix for the x86_64 allmodconfig build failures I
reported against linux-next?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Jul_2008_01_21_53_+1000_A9CajdDdysRifjpg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh7bxEACgkQjjKRsyhoI8wskgCfd3IABCye6wrg7UkPVYwwqSTL
NVQAoLFu7azbevYwUOLh7JthVKDL0ON1
=cKp0
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jul_2008_01_21_53_+1000_A9CajdDdysRifjpg--
