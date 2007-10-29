Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbXJ2ROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbXJ2ROK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXJ2RN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:13:56 -0400
Received: from home.keithp.com ([63.227.221.253]:4403 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbXJ2RNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:13:55 -0400
Subject: Re: [RFC] AGP initial support for chipset flushing..
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@skynet.ie>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-INTP1KM69tNpnU42ilah"
Date: Mon, 29 Oct 2007 08:50:44 -0700
Message-Id: <1193673044.18435.31.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-INTP1KM69tNpnU42ilah
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-10-29 at 08:15 +0000, Dave Airlie wrote:

> The attached patches add a new AGP interface  for this purpose and=20
> implements this in the Intel AGP driver. This stuff is based of some=20
> guesswork in the 915 case from comments in the documentation :).

The relevant register lives in device 0, which is why this is an AGP
interface and not just hidden inside the DRM driver directly.

--=20
keith.packard@intel.com

--=-INTP1KM69tNpnU42ilah
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHJgFUQp8BWwlsTdMRAqedAKDmYnu3QvEUjECeW05wutWV/cVqYwCcC856
TpRHoSrXGSzAN1duNwarGFI=
=2GuF
-----END PGP SIGNATURE-----

--=-INTP1KM69tNpnU42ilah--

