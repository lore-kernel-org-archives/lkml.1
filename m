Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbYFIXQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbYFIXQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYFIXP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:15:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51784 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbYFIXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:15:59 -0400
Date: Tue, 10 Jun 2008 09:15:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>, TKLEIN@de.ibm.com,
       fenkes@de.ibm.com, raisch@de.ibm.com, THEMANN@de.ibm.com
Subject: Re: [PATCH 1/2] ibmebus: Change ibmebus_request_irq() to optionally
 return irq number
Message-Id: <20080610091545.eb36d72f.sfr@canb.auug.org.au>
In-Reply-To: <200806091744.30930.ossrosch@linux.vnet.ibm.com>
References: <200806091744.30930.ossrosch@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jun_2008_09_15_45_+1000_KSWuMORr5A4Yt6.m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jun_2008_09_15_45_+1000_KSWuMORr5A4Yt6.m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Mon, 9 Jun 2008 17:44:29 +0200 Stefan Roscher <ossrosch@linux.vnet.ibm.c=
om> wrote:
>
> Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>

Before Paulus gets to you:  Why are we doing this?  Please write an
explanatory commit message.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jun_2008_09_15_45_+1000_KSWuMORr5A4Yt6.m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhNuaEACgkQTgG2atn1QN9a/QCfTnObsOEEainNPvQaRDPhBLKv
j9UAoIPBPZVy8IBXcJ7pNRAonJW1xFS3
=6Sx0
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jun_2008_09_15_45_+1000_KSWuMORr5A4Yt6.m--
