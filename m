Return-Path: <linux-kernel-owner+w=401wt.eu-S937545AbYEVARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937545AbYEVARg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYEVAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:17:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38668 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYEVAR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:17:26 -0400
Date: Thu, 22 May 2008 10:17:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: rolandd@cisco.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix
 compiler warnings
Message-Id: <20080522101714.3f2c5a82.sfr@canb.auug.org.au>
In-Reply-To: <48342C6C.2010502@googlemail.com>
References: <48342C6C.2010502@googlemail.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_May_2008_10_17_14_+1000_c55k.Xbnz4g=xY=V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_May_2008_10_17_14_+1000_c55k.Xbnz4g=xY=V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gabriel,

We appreciate the reports, thanks.

On Wed, 21 May 2008 16:06:36 +0200 Gabriel C <nix.or.die@googlemail.com> wr=
ote:
>
> On linux-next from today, allmodconfig, I see the following warnings on 6=
4bit:

What architecture are you building on?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_May_2008_10_17_14_+1000_c55k.Xbnz4g=xY=V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINLuNTgG2atn1QN8RAhQoAJ4gFNHRd6D8/2dGib87vCL36bb/ZwCbBBcX
obAKgN2E9zcK2/TgRaeFneU=
=2Ljb
-----END PGP SIGNATURE-----

--Signature=_Thu__22_May_2008_10_17_14_+1000_c55k.Xbnz4g=xY=V--
