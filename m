Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZETAvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZETAvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZETAv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:51:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49078 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZETAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:51:28 -0400
Date: Wed, 20 May 2009 10:51:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tape: beyond ARRAY_SIZE of viocd_diskinfo
Message-Id: <20090520105124.f758bab3.sfr@canb.auug.org.au>
In-Reply-To: <4A133C6D.9050300@gmail.com>
References: <4A133C6D.9050300@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_May_2009_10_51_24_+1000_RUi=jpGLDxRN6uD0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_May_2009_10_51_24_+1000_RUi=jpGLDxRN6uD0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roel,

On Wed, 20 May 2009 01:10:37 +0200 Roel Kluin <roel.kluin@gmail.com> wrote:
>
> Do not go beyond ARRAY_SIZE of tape_device and viotape_unitinfo
>=20
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Good catch.

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

If you don't want to trouble with carrying this, please submit it to
linuxppc-dev@ozlabs.org (with my Ack) and they will track it and take
care of it eventually.  This is a legacy driver and noone is likely to
have enough tape drives attached to such a machine so is not an urgent
issue.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_May_2009_10_51_24_+1000_RUi=jpGLDxRN6uD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoTVAwACgkQjjKRsyhoI8xSQgCfTcc2d6Lc0ldzNWsLzJ2fTXTg
7vAAn3Ludg+nTZeZyiAGyAydXXeep41s
=S3Q4
-----END PGP SIGNATURE-----

--Signature=_Wed__20_May_2009_10_51_24_+1000_RUi=jpGLDxRN6uD0--
