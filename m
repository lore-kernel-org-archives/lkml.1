Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbXGEN6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbXGEN6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbXGEN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:58:21 -0400
Received: from saltmine.radix.net ([207.192.128.40]:43419 "EHLO
	saltmine.radix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbXGEN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:58:20 -0400
Date: Thu, 5 Jul 2007 09:29:14 -0400
From: Thomas Dickey <dickey@radix.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Keith Packard <keith.packard@intel.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070705132914.GA9003@saltmine.radix.net>
References: <8yZun-1bO-5@gated-at.bofh.it> <8CszT-4hd-11@gated-at.bofh.it> <8CtPi-6qj-9@gated-at.bofh.it> <8Cus1-7eL-11@gated-at.bofh.it> <8CwtU-1Z5-3@gated-at.bofh.it> <8Cxgd-3fN-9@gated-at.bofh.it> <8CKQ8-7HN-13@gated-at.bofh.it> <8CKZV-7Ur-11@gated-at.bofh.it> <8CLCt-vX-3@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <8CLCt-vX-3@gated-at.bofh.it>
User-Agent: Mutt/1.3.27i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2007 at 10:10:05AM +0200, Keith Packard wrote:
> On Tue, 2007-07-03 at 09:22 +0200, Ingo Molnar wrote:
>=20
> > which allows xterm-spam (attached) to easily flood the xterm (without=
=20
> > any scrolling that would act as a throttle) and the xterm to flood Xorg=
.=20

=2E..deleting the offhand remarks

=2E..here's a little content:

> And, as the kernel will not buffer more than 4095 bytes from a pty,
> there isn't any way it will ever read 4096 bytes.

The sched_yield() call was added to address problems in an earlier
2.6.x kernel (and the report then stated that it could read more than
4096 because it would have to perform several reads to keep up with
a burst of output).
=20
=2E..deleting the other offhand remarks


--=20
Thomas E. Dickey
http://invisible-island.net
ftp://invisible-island.net

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (SunOS)
Comment: For info see http://www.gnupg.org

iD8DBQFGjO7ctIqByHxlDocRAu6WAJ4z3YZcXKGVroj24gVyn4qak5iq3wCbBhPW
4W86UKrJKNeWpX1Sy7y1siM=
=EEkz
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
