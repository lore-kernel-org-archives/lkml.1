Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167Ab0AUXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0AUXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065Ab0AUXBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:01:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab0AUXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:01:06 -0500
Date: Fri, 22 Jan 2010 10:00:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Tilman Schmidt <tilman@imap.cc>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for January 21
Message-Id: <20100122100059.9007bdb8.sfr@canb.auug.org.au>
In-Reply-To: <20100121131339.5e86dfef.akpm@linux-foundation.org>
References: <20100121165713.7b8a746d.sfr@canb.auug.org.au>
	<20100121131339.5e86dfef.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Jan_2010_10_00_59_+1100_z+rjg3NRLk18NkG7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jan_2010_10_00_59_+1100_z+rjg3NRLk18NkG7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 21 Jan 2010 13:13:39 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> It includes this screwed up commit:
>=20
> :commit e303d9eadc64907535a0a104afa5871d2b83275e
> :Author:     Tilman Schmidt <tilman@imap.cc>
> :AuthorDate: Thu Jan 14 23:18:41 2010 +0100
> :Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
> :CommitDate: Fri Jan 15 10:08:07 2010 -0800
> :
> :    PCI/ISDN: push deprecated pci_find_device() function to last user (i=
sdn)
>=20
> It adds a bunch of files which are compile-time generated:

Thanks for noticing.  I will revert that commit today since it is still
in the pci tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Jan_2010_10_00_59_+1100_z+rjg3NRLk18NkG7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktY3KsACgkQjjKRsyhoI8z00QCfZYjh3I1Z0Z+1rJXq/2i6CH6S
SGoAoJXh0rIkC3EAEwPwbZ4Pb7fJO6B3
=HSzw
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jan_2010_10_00_59_+1100_z+rjg3NRLk18NkG7--
