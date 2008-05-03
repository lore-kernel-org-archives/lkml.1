Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYECEeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYECEeC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 00:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYECEdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 00:33:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58531 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYECEdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 00:33:50 -0400
Date: Sat, 3 May 2008 14:33:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, stefanr@s5r6.in-berlin.de,
       ralf@linux-mips.org, drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru,
       jens.axboe@oracle.com, ericvh@gmail.com, wim@iguana.be,
       chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080503143335.01b956f3.sfr@canb.auug.org.au>
In-Reply-To: <20080502153301.8b27ac31.akpm@linux-foundation.org>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<481B93AA.7040000@garzik.org>
	<20080502153301.8b27ac31.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_May_2008_14_33_35_+1000_W0a0jCvt0UfHV5hZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_May_2008_14_33_35_+1000_W0a0jCvt0UfHV5hZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 2 May 2008 15:33:01 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Fri, 02 May 2008 18:20:26 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
>=20
> > Andrew Morton wrote:
> > > (Jeff, git-libata-all is a pretty important one)
> >=20
> > libata-dev.git#NEXT is for linux-next, and libata-dev.git#ALL is for -mm
> >=20
> > Already taken care of.
>=20
> Oh.  Something seems to have gone wrong then.
>=20
> Next/Trees has:
>=20
> libata          git     git://git.kernel.org/pub/scm/linux/kernel/git/jga=
rzik/libata-dev.git#NEXT
>=20
> but:
>=20
> y:/usr/src/25> diffstat patches/linux-next.patch | grep /ata/     =20
>=20
> There's nothing there?

This just means that everything that Jeff expected to go into 2.6.26 is
not in Linus' tree, right?  And he hasn't moved his 2.6.27 expectations
into linux-next yet (after all we are still in the 2.6.26 merge window).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_May_2008_14_33_35_+1000_W0a0jCvt0UfHV5hZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIG+skTgG2atn1QN8RAvJPAJwOVFM2tjWz4WAdyEWa731u2J5bgACffuZb
rIvXLn5zUy49pVhAOjht92E=
=z87C
-----END PGP SIGNATURE-----

--Signature=_Sat__3_May_2008_14_33_35_+1000_W0a0jCvt0UfHV5hZ--
