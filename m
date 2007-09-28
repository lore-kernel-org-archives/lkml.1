Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbXI1JXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbXI1JXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXI1JXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:23:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26068 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755220AbXI1JXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:23:42 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chakri n <chakriin5@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <92cbf19b0709280220o7cdd4b1cua37a8776af68ac25@mail.gmail.com>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190962752.31636.15.camel@twins>
	 <92cbf19b0709280127yba48b60wfe58e532944894ca@mail.gmail.com>
	 <1190968800.31636.26.camel@twins>
	 <92cbf19b0709280201o3778f945mf1d8d61cbb3d0558@mail.gmail.com>
	 <1190970729.31636.29.camel@twins>
	 <92cbf19b0709280220o7cdd4b1cua37a8776af68ac25@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6L5l2lrn9QSVICL21ufD"
Date: Fri, 28 Sep 2007 11:23:39 +0200
Message-Id: <1190971419.31636.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6L5l2lrn9QSVICL21ufD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

 [ and one copy for the list too ]

On Fri, 2007-09-28 at 02:20 -0700, Chakri n wrote:
> It's 2.6.23-rc6.

Could you try .23-rc8-mm2. It includes the per bdi stuff.

--=-6L5l2lrn9QSVICL21ufD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG/MgbXA2jU0ANEf4RAlRtAKCOr5llD1VvWGyDFlYDq2rtx5ux1gCfQhUe
h96SD0We8xHaqudJfr1QKSw=
=bwEO
-----END PGP SIGNATURE-----

--=-6L5l2lrn9QSVICL21ufD--

