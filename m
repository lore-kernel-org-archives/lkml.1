Return-Path: <linux-kernel-owner+w=401wt.eu-S937208AbXG0KDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937208AbXG0KDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbXG0KDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:03:16 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60377 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbXG0KDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:03:15 -0400
Date: Fri, 27 Jul 2007 12:02:01 +0200
From: Christian Krafft <krafft@de.ibm.com>
To: Christian Krafft <krafft@de.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
 nfs_free_open_context
Message-ID: <20070727120201.5f4d7aa1@localhost>
In-Reply-To: <20070726200047.1225c084@localhost>
References: <20070725170837.5fba5fd1@localhost>
	<20070726144433.080126f7@localhost>
	<1185456203.6585.180.camel@localhost>
	<200707261713.07936.arnd@arndb.de>
	<1185466097.6585.186.camel@localhost>
	<20070726200047.1225c084@localhost>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
X-Face: `W@`hRxh5l!3-i=A%w>*|0PiG}G;2Y!DoiUjUcBX:Xf)vV'7+Is>5$*66xg5jwQA8P65#e
 <*gu)O37;+RS9iC[c7wnR]O0%dkLr^g_f1`&sfIQe&BG$E)b=GyjfCE$Ao'.6#^8@+z^`v
 qs#^Z%sWk_290zu+7nql/d?=lf<5^JI(C?MeXv;Tz)`xYOe<*"3'M?r2NHOdm_&jy-0Gp,
 3VVLR;cE=X-;J?p6b~_?K+jTAJrnGuuO%<!$3".gR,z_~jYJ"be)qH1(1A?koh`}d6Le|k
 CE<Y)JAsm
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_C=lHNjpoYLaIgiHvgn454SC";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_C=lHNjpoYLaIgiHvgn454SC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Thu, 26 Jul 2007 20:00:47 +0200
Christian Krafft <krafft@de.ibm.com> wrote:

>=20
> Indeed, and it also compiles ;-)
> I started a test run using this patch, we'll see in a few hours ...
>=20

Scripts were running over night, no hang occurred.
Would be great to see this patch integrated.


--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294


--Sig_C=lHNjpoYLaIgiHvgn454SC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGqcK36rqK4qDx+dcRAkF8AJwJPVXg19vls+8/QEoCj7QRjYUgLACg3jOH
HnOADeqbWBkR0MCaXFTQ1gA=
=BCX5
-----END PGP SIGNATURE-----

--Sig_C=lHNjpoYLaIgiHvgn454SC--
