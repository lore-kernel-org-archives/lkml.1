Return-Path: <linux-kernel-owner+w=401wt.eu-S937627AbYEVAQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937627AbYEVAQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761091AbYEVAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:15:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbYEVAPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:15:49 -0400
Date: Thu, 22 May 2008 10:15:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for May 19/20/21 - BUG at
 arch/x86/kernel/io_apic_64.c:353!
Message-Id: <20080522101536.c449e082.sfr@canb.auug.org.au>
In-Reply-To: <48345B5E.1090506@linux.vnet.ibm.com>
References: <20080519174120.2083ea57.sfr@canb.auug.org.au>
	<48315607.4080207@linux.vnet.ibm.com>
	<48345B5E.1090506@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_May_2008_10_15_36_+1000_KaYAXz.59QTIAcww"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_May_2008_10_15_36_+1000_KaYAXz.59QTIAcww
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Wed, 21 May 2008 22:56:54 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>=20
> This kernel panic while booting up is reproducible with the next-20080519=
,=20
> next-20080520 and next-20080521 kernels.

Thanks for the reports.

Can you include the config when you send these, please.  If it a standard
config then just say "defconfig" (or whatever) otherwise please attach
the config you used.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_May_2008_10_15_36_+1000_KaYAXz.59QTIAcww
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINLswTgG2atn1QN8RAnnLAJ4klNfKT9UXyGDzTHNIZiflmT46HQCgkUBu
dZihCo7cfYZAqXixoB3EkRM=
=N7MC
-----END PGP SIGNATURE-----

--Signature=_Thu__22_May_2008_10_15_36_+1000_KaYAXz.59QTIAcww--
