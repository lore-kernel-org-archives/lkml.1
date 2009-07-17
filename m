Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZGQELE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZGQELE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZGQELD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:11:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33220 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZGQELB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:11:01 -0400
Date: Fri, 17 Jul 2009 14:10:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Noah Watkins <jayhawk@soe.ucsc.edu>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: regression: wireless authentication
Message-Id: <20090717141047.7ce77136.sfr@canb.auug.org.au>
In-Reply-To: <20090717035706.GA5923@martini>
References: <20090717035706.GA5923@martini>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jul_2009_14_10_47_+1000_7NAwRZrSTZuX2L/B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jul_2009_14_10_47_+1000_7NAwRZrSTZuX2L/B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Noah,

Lets cc some people who may be able to help ...

On Thu, 16 Jul 2009 20:57:06 -0700 Noah Watkins <jayhawk@soe.ucsc.edu> wrot=
e:
>
> With 2.6.31-rc3-next-20090716 all wireless access points are detected, but
> authentication fails. I haven't verified on an access point w/o WPA.
>=20
> 2.6.31-rc3 functions fine. I haven't been able to complete a bisect yet.
>=20
> 05:01.0 Network controller: Atheros Communications Inc. AR5008 Wireless N=
etwork
> Adapter (rev 01)
>=20
> noah

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jul_2009_14_10_47_+1000_7NAwRZrSTZuX2L/B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpf+ccACgkQjjKRsyhoI8yRSACfW1gpH6bfQDVgjiZLb+8sqFEx
80UAn3ql/e2nB2LJLkbkFEiYlhdLF9N4
=AM5x
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jul_2009_14_10_47_+1000_7NAwRZrSTZuX2L/B--
