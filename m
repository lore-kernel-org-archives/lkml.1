Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZGOJ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZGOJ6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZGOJ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:58:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35491 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZGOJ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:58:12 -0400
Date: Wed, 15 Jul 2009 19:58:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for July 6-July 9-July 15 (percpu/x86)
Message-Id: <20090715195807.f0d1a7ea.sfr@canb.auug.org.au>
In-Reply-To: <20090715094720.GA6674@linux.vnet.ibm.com>
References: <20090706162632.fdde002e.sfr@canb.auug.org.au>
	<20090706095343.df21d4c9.rdunlap@xenotime.net>
	<20090709102248.01e2312c.randy.dunlap@oracle.com>
	<20090715094720.GA6674@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jul_2009_19_58_07_+1000_ceF_Tz.5/rk0CUmM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jul_2009_19_58_07_+1000_ceF_Tz.5/rk0CUmM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 15 Jul 2009 15:17:20 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> * Randy Dunlap <randy.dunlap@oracle.com> [2009-07-09 10:22:48]:
>=20
> > On Mon, 6 Jul 2009 09:53:43 -0700 Randy Dunlap wrote:
> >=20
> > > On Mon, 6 Jul 2009 16:26:32 +1000 Stephen Rothwell wrote:
> > >=20
> > > > Changes since 20090703:
> > > >=20
> > > > The percpu tree lost all its conflicts but gained another against t=
he tip
> > > > tree.
> > >=20
> > > arch/x86/mm/pageattr.c: In function 'cpa_process_alias':
> > > arch/x86/mm/pageattr.c:749: error: implicit declaration of function '=
pcpu_lpage_remapped'
> > >=20
> > > config attached.
> >=20
> >=20
> > Still present in 20090709...
> >=20
> still seen in 20090715 with allnoconfig.

Any ideas?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jul_2009_19_58_07_+1000_ceF_Tz.5/rk0CUmM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpdqC8ACgkQjjKRsyhoI8wx/ACeJgaEZMjTnBNvUfSt3Mvme8QS
O00AnjM2LZRGTnUPzVux+g6QLa0g9Jya
=OBt5
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jul_2009_19_58_07_+1000_ceF_Tz.5/rk0CUmM--
