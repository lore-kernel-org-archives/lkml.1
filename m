Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbXJ2DYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbXJ2DYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbXJ2DYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:24:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48554 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXJ2DYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:24:37 -0400
Date: Mon, 29 Oct 2007 14:24:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: nr_slabs is an atomic_long_t
Message-Id: <20071029142430.fd711666.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0710281953460.28636@schroedinger.engr.sgi.com>
References: <20071029131540.13932677.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0710281953460.28636@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Oct_2007_14_24_30_+1100_ZcV1Ey37w+5FIBwc"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2007_14_24_30_+1100_ZcV1Ey37w+5FIBwc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Oct 2007 19:53:55 -0700 (PDT) Christoph Lameter <clameter@sgi.co=
m> wrote:
>
> That was already fixed AFAICT.

Not in Linus' tree, yet.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Oct_2007_14_24_30_+1100_ZcV1Ey37w+5FIBwc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJVJzTgG2atn1QN8RAgG1AKCLcBxSZe+qtqIi1e996D1d8HZpWgCcC4Ys
zzrzCsI0HPAr8SGccsn/yic=
=axac
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2007_14_24_30_+1100_ZcV1Ey37w+5FIBwc--
