Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243Ab0ARCmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0ARCmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751Ab0ARCme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:42:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0ARCme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:42:34 -0500
Date: Mon, 18 Jan 2010 13:42:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for January 14 (drm header files)
Message-Id: <20100118134221.0c36feb3.sfr@canb.auug.org.au>
In-Reply-To: <20100117151718.f88c5f21.randy.dunlap@oracle.com>
References: <20100114172047.406ebda8.sfr@canb.auug.org.au>
	<20100117151718.f88c5f21.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_13_42_21_+1100_kIT1TFen_YF2N9Vv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_13_42_21_+1100_kIT1TFen_YF2N9Vv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just cc'd Dave]

On Sun, 17 Jan 2010 15:17:18 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>=20
> Is anything being done about these?
> or does anything need to be done?
>=20
>=20
> usr/include/drm/drm_mode.h:84: found __[us]{8,16,32,64} type without #inc=
lude <linux/types.h>
> usr/include/drm/i915_drm.h:119: found __[us]{8,16,32,64} type without #in=
clude <linux/types.h>
> usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #inc=
lude <linux/types.h>
> usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #=
include <linux/types.h>
> usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #inc=
lude <linux/types.h>
>=20
>=20
> Thanks,
> ---
> ~Randy

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_13_42_21_+1100_kIT1TFen_YF2N9Vv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktTyo0ACgkQjjKRsyhoI8y99QCgtucuf3EKHUPcWaEpGrOv3zIT
lg8AoKffatVEyzqokOpRuN+zVqYozcdY
=7zje
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_13_42_21_+1100_kIT1TFen_YF2N9Vv--
