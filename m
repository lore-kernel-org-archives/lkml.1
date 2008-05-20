Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbYETETT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbYETETT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYETETK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:19:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33705 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYETETJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:19:09 -0400
Date: Tue, 20 May 2008 14:19:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 19
Message-Id: <20080520141901.6395a2a1.sfr@canb.auug.org.au>
In-Reply-To: <1211222520.30161.3.camel@dhcppc1>
References: <20080519174120.2083ea57.sfr@canb.auug.org.au>
	<1211222520.30161.3.camel@dhcppc1>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_May_2008_14_19_01_+1000_EvQ5ZPP63iJl/jjc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_May_2008_14_19_01_+1000_EvQ5ZPP63iJl/jjc
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, 19 May 2008 20:42:00 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
>
> Is it intentional that kernel.release is:
>=20
> $ cat include/config/kernel.release=20
> 2.6.26-rc3-next-20080519-sched-devel.git
>=20
> all predecessors have had names like:
> =EF=BB=BF2.6.26-rc2-next-20080516

It was not intentional, I missed it sneaking in.  It seems to be gone
again today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_May_2008_14_19_01_+1000_EvQ5ZPP63iJl/jjc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIMlE5TgG2atn1QN8RAtrKAJ0eozOwI60iRtYIGMcm6kz9ptBjrwCeOHK9
NRPBTe0eATOS4G+GVQa3/zI=
=rfqt
-----END PGP SIGNATURE-----

--Signature=_Tue__20_May_2008_14_19_01_+1000_EvQ5ZPP63iJl/jjc--
