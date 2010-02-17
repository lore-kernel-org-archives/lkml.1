Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab0BQGqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 01:46:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47521 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555Ab0BQGqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 01:46:43 -0500
Date: Wed, 17 Feb 2010 17:46:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after final merge (net tree)
Message-Id: <20100217174636.8f1fc499.sfr@canb.auug.org.au>
In-Reply-To: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
References: <20100217174015.d1a8a478.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Feb_2010_17_46_36_+1100_1bFPo2UVnjGaARu3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Feb_2010_17_46_36_+1100_1bFPo2UVnjGaARu3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Feb 2010 17:40:15 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Caused by commit 2b95efe7f6bb750256a702cc32d33b0cb2cd8223 ("netfilter:
> xtables: use xt_table for hook instantiation").  Missing direct include
> of linux/netfilter.h?

The address for Jan Engelhardt is bouncing ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Feb_2010_17_46_36_+1100_1bFPo2UVnjGaARu3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt7kMwACgkQjjKRsyhoI8xjvgCgvkIOpOx8advseNaiGyGJpwU9
IeEAn0Ids8qq3+d37f1Dho+aUmcQigLu
=x/p8
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Feb_2010_17_46_36_+1100_1bFPo2UVnjGaARu3--
