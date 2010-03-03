Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0CCGbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:31:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44343 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab0CCGbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:31:34 -0500
Date: Wed, 3 Mar 2010 17:31:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100303173125.1aa2d004.sfr@canb.auug.org.au>
In-Reply-To: <20100303171432.bee7ae0c.sfr@canb.auug.org.au>
References: <20100303171432.bee7ae0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_17_31_25_+1100_m+P6fFmUSnn5xcvs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_17_31_25_+1100_m+P6fFmUSnn5xcvs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 3 Mar 2010 17:14:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> John, Johannes, device_lock/unlock() already exist in Linus' tree, so you
> should be able to apply this to the wireless tree already.

This is not correct, sorry.  I was thinking of something else.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_17_31_25_+1100_m+P6fFmUSnn5xcvs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuOAj0ACgkQjjKRsyhoI8w5DgCcCoxwgb8MNUpuKD6iLJ/GYVWB
kygAoJz8W8VUZ+PUcVL9vE9HXejqvv7H
=dFuN
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_17_31_25_+1100_m+P6fFmUSnn5xcvs--
