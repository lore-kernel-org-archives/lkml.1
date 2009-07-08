Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZGHAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZGHAmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZGHAmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:42:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbZGHAmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:42:08 -0400
Date: Wed, 8 Jul 2009 10:41:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: block tree build failure
Message-Id: <20090708104159.2de0dc03.sfr@canb.auug.org.au>
In-Reply-To: <20090707135541.GA4997@infradead.org>
References: <20090707134908.e81b1556.sfr@canb.auug.org.au>
	<20090707135541.GA4997@infradead.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jul_2009_10_41_59_+1000_452eLPAbZjCoznON"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jul_2009_10_41_59_+1000_452eLPAbZjCoznON
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Tue, 7 Jul 2009 09:55:42 -0400 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Tue, Jul 07, 2009 at 01:49:08PM +1000, Stephen Rothwell wrote:
> > interacting with commit 3beab0b42413e83a7907db7176b54c840fc75a81
> > ("sys_sync(): fix 16% performance regression in ffsb create_4k test")
> > from Linus' tree.
>=20
> Where the fuck is that patch coming from?  For one that's a horrible
> patch subject and second I can't see it anywhere on -fsdevel.  We
> removed that bdflush wakeup for a reason, and if it causes problems
> those need to be discussed and fixed properly instead of papering over
> it.

http://lkml.org/lkml/2009/6/29/52

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jul_2009_10_41_59_+1000_452eLPAbZjCoznON
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpT61cACgkQjjKRsyhoI8xuyQCfU4b+/AISAx/Bk0PwS8bXZUpc
R4gAn2XN92aLmqwA72aRNY0aP+vknL10
=Tq7l
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jul_2009_10_41_59_+1000_452eLPAbZjCoznON--
