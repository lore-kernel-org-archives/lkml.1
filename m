Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZFXHuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZFXHuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZFXHty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:49:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40722 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZFXHty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:49:54 -0400
Date: Wed, 24 Jun 2009 17:49:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Len Brown <lenb@kernel.org>,
       Avi Kivity <avi@qumranet.com>, Jens Axboe <jens.axboe@oracle.com>,
       Richard Purdie <rpurdie@rpsys.net>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Main things left in linux-next
Message-Id: <20090624174950.dd59e733.sfr@canb.auug.org.au>
In-Reply-To: <4A41D939.40507@garzik.org>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au>
	<20090624172735.9b500674.sfr@canb.auug.org.au>
	<4A41D939.40507@garzik.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Jun_2009_17_49_50_+1000_TI7S=qBPj7Qz/QeF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jun_2009_17_49_50_+1000_TI7S=qBPj7Qz/QeF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Wed, 24 Jun 2009 03:43:53 -0400 Jeff Garzik <jeff@garzik.org> wrote:
>
> Stephen Rothwell wrote:
> > The main obvious things left are:
> >=20
> > osdblk from the osd tree
>=20
>=20
> I thought Boaz pushed this one the other day...

I guess Linus just hasn't taken it yet, then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Jun_2009_17_49_50_+1000_TI7S=qBPj7Qz/QeF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpB2p4ACgkQjjKRsyhoI8yiAQCgtpbzjxIpA7Ot4wzK7pS2/61U
OYkAoJhabVVZ/Fop2zcOOCXGIzD6nHw8
=hYCV
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jun_2009_17_49_50_+1000_TI7S=qBPj7Qz/QeF--
