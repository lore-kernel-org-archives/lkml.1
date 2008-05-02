Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYEBBtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYEBBtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbYEBBtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:49:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49734 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbYEBBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:49:01 -0400
Date: Fri, 2 May 2008 11:48:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Diego Calleja <diegocg@gmail.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
Message-Id: <20080502114848.000fd656.sfr@canb.auug.org.au>
In-Reply-To: <20080501182658.9bbf5d4a.diegocg@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080430135405.ddc42075.akpm@linux-foundation.org>
	<4818E7E3.7080705@gmail.com>
	<20080430151007.0ace4fa2.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
	<4818F291.2050706@gmail.com>
	<20080501182658.9bbf5d4a.diegocg@gmail.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__2_May_2008_11_48_48_+1000_GBhnpParZz0=VlzR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_May_2008_11_48_48_+1000_GBhnpParZz0=VlzR
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 1 May 2008 18:26:58 +0200 Diego Calleja <diegocg@gmail.com> wrote:
>
> El Thu, 01 May 2008 02:28:33 +0400, Dmitri Vorobiev <dmitri.vorobiev@gmai=
l.com> escribi=C3=B3:
>=20
> > Linus, thanks a lot for the detailed explanation. Indeed, it seems that=
 I foolishly
> > tried to duplicate Stephen's work. In the future I'll do as you suggest=
 here.
>=20
> That "howto" should probably be added to the linux-next announcements...
> (CC'ing Stephen)

This is already mentioned in the linux-next wiki
(http://linux.f-seidel.de/linux-next/pmwiki/) in the FAQ.  I will add a
link to the wiki to the announcements.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__2_May_2008_11_48_48_+1000_GBhnpParZz0=VlzR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGnMHTgG2atn1QN8RAlBhAJ9Wml0TIh4VdVGS3RPvlRTgTFKaQACePwno
fT0tr54HWd4p9GvE3Dl1Pwo=
=CXoR
-----END PGP SIGNATURE-----

--Signature=_Fri__2_May_2008_11_48_48_+1000_GBhnpParZz0=VlzR--
