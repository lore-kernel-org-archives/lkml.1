Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0BPXJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:09:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114Ab0BPXJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:09:10 -0500
Date: Wed, 17 Feb 2010 10:09:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge final merge
Message-Id: <20100217100904.2209abc8.sfr@canb.auug.org.au>
In-Reply-To: <201002161041.56138.bjorn.helgaas@hp.com>
References: <20100216183650.e82c0f8e.sfr@canb.auug.org.au>
	<201002161003.29713.bjorn.helgaas@hp.com>
	<201002161041.56138.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Feb_2010_10_09_04_+1100_Tlw+lXdTPvbdQgBw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Feb_2010_10_09_04_+1100_Tlw+lXdTPvbdQgBw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Tue, 16 Feb 2010 10:41:55 -0700 Bjorn Helgaas <bjorn.helgaas@hp.com> wro=
te:
>
> BTW, do you have cross-compilers for all those targets?  It'd be great
> if they were all available somewhere.  My set is incomplete and getting
> old.

There are various cross-compilers (x86 hosted) available at
http://bakeyournoodle.com/cross/ .  These are only good for building
kernels as they have no libc stuff.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Feb_2010_10_09_04_+1100_Tlw+lXdTPvbdQgBw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt7JZAACgkQjjKRsyhoI8zSgwCfem+/QpFIW+fnwyz9DWQFxyR4
o3gAoJB5BAWvYiMcST06K5iN7U6nhqLu
=0FsH
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Feb_2010_10_09_04_+1100_Tlw+lXdTPvbdQgBw--
