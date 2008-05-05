Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYEEAS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYEEAS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYEEASs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:18:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYEEASr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:18:47 -0400
Date: Mon, 5 May 2008 10:18:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       ralf@linux-mips.org, drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru,
       jens.axboe@oracle.com, ericvh@gmail.com, wim@iguana.be,
       chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-Id: <20080505101831.af758942.sfr@canb.auug.org.au>
In-Reply-To: <481C266F.9080003@s5r6.in-berlin.de>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<20080502154200.a6d8c43a.akpm@linux-foundation.org>
	<481BBD84.10904@s5r6.in-berlin.de>
	<20080502183403.3d9f2d9f.akpm@linux-foundation.org>
	<481BEF7A.1060300@garzik.org>
	<481C266F.9080003@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_May_2008_10_18_31_+1000_Z7nsAznQ4FDjMX0O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2008_10_18_31_+1000_Z7nsAznQ4FDjMX0O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 03 May 2008 10:46:39 +0200 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> Of course some committers have more than one tree in -next.  So if=20
> Andrew wants to know the actual tree, the laziest method which I know of =
is
> $ gitk <commit_id>
>=20
> Among else, gitk shows which branches contain the commit.  (How to do=20
> this without X GUI?)

Unfortunately, this will not work either as I do not export to the public
tree the heads of each of the branches that I merge.  It does work in my
tree until I do the next update.

However, if you look at the closest following merge that is committed by
me, that will tell you which branch the commit was on.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_May_2008_10_18_31_+1000_Z7nsAznQ4FDjMX0O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHlJbTgG2atn1QN8RAo7YAJwIsnqT909BYWkq94062ZMV6B+pVQCfYk5e
IHcXlcueXaw3f2e8r97pIy0=
=mODf
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2008_10_18_31_+1000_Z7nsAznQ4FDjMX0O--
