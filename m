Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYLKDPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYLKDPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 22:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYLKDOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 22:14:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42188 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbYLKDOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 22:14:45 -0500
Date: Thu, 11 Dec 2008 14:14:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs trees for linux-next
Message-Id: <20081211141436.030c2d65.sfr@canb.auug.org.au>
In-Reply-To: <1228962896.21376.11.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	<1228962896.21376.11.camel@think.oraclecorp.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 10 Dec 2008 21:34:56 -0500 Chris Mason <chris.mason@oracle.com> wro=
te:
>
> Just an update, while I still have a long todo list and plenty of things
> to fix in the code, these src trees have been updated with a disk format
> I hope to maintain compatibility with from here on.  There are still
> format changes planned, but should go in through the compat mechanisms
> in the sources now.
>=20
> The btrfs trees are still at 2.6.28-rc5, but I just tested against
> linux-next without problems.

Do you think this is ready to be added to the end of linux-next, yet?  Or
is this more -mm material?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklAhZwACgkQjjKRsyhoI8yYJwCfRO749pIw7+/FZIXk7776VO5j
27IAmwWCza0BGP8lIpPhdT1rxo23LlOl
=JsVf
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ--
