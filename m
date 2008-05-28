Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYE1GCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYE1GCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 02:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYE1GCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 02:02:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53240 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYE1GCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 02:02:08 -0400
Date: Wed, 28 May 2008 16:01:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH -next] block: genhd errors when CONFIG_PROC_FS=n
Message-Id: <20080528160158.775932b5.sfr@canb.auug.org.au>
In-Reply-To: <20080527222036.1141e43a.akpm@linux-foundation.org>
References: <20080523094411.06f173e0.randy.dunlap@oracle.com>
	<20080527222036.1141e43a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_May_2008_16_01_58_+1000__rX.On58Al+ZTiAX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_May_2008_16_01_58_+1000__rX.On58Al+ZTiAX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 27 May 2008 22:20:36 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> This is a fix against
>=20
> commit ce8568d9535b4756ea304a97ea803314ce895d3c
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Thu May 22 17:21:08 2008 -0400

Yeah,  Greg has added it to his series for tomorrow and I have added it
to the end of linux-next for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_May_2008_16_01_58_+1000__rX.On58Al+ZTiAX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIPPVdTgG2atn1QN8RAp2fAKCKiz4o3TzTabVRRyLBfZ9lG7jaogCePn4o
2de/YC3fT7uWKPCQwfo/7FQ=
=vHYY
-----END PGP SIGNATURE-----

--Signature=_Wed__28_May_2008_16_01_58_+1000__rX.On58Al+ZTiAX--
