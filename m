Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbYBTOOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbYBTOOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbYBTON5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:13:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40028 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbYBTON4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:13:56 -0500
Date: Thu, 21 Feb 2008 01:13:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       haveblue@us.ibm.com, linuxram@us.ibm.com, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: git tree with VFS stuff
Message-Id: <20080221011348.ef5da6c5.sfr@canb.auug.org.au>
In-Reply-To: <E1JRSaC-0005T2-Ew@pomaz-ex.szeredi.hu>
References: <E1JRSaC-0005T2-Ew@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Feb_2008_01_13_48_+1100_QcCNV3vW.M.J+tOX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2008_01_13_48_+1100_QcCNV3vW.M.J+tOX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Miklos,

On Tue, 19 Feb 2008 14:32:28 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> I've created a git tree with the following mounts related stuff:
>=20
>   - read-only bind mounts
>   - /proc/<pid>/mountinfo
>   - unprivileged mounts
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfsstuff.git master
>=20
> I guess, giving these a spin in linux-next wouldn't hurt?

I don't think this is what we want to use linux-next for.  Linux-next is
really a place for stuff that will pretty clearly go into the next kernel
release i.e. 2.6.26 right now.  If you want to experiment on things for
beyond that timeframe, then a snapshot of linux-next may be a good base.
I will take them when they reach the appropriate subsystem tree and are
ready for integration.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Feb_2008_01_13_48_+1100_QcCNV3vW.M.J+tOX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvDWhTgG2atn1QN8RAiLrAJ46p80TvrjvgxSEqzfh3XjJ8owuIwCdHNik
gZvWxJyeWxymq9S6aJQF2m0=
=zCOW
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2008_01_13_48_+1100_QcCNV3vW.M.J+tOX--
