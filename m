Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbYBZXOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbYBZXOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbYBZXNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:13:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53462 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbYBZXNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:13:42 -0500
Date: Wed, 27 Feb 2008 10:13:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: -next build logs
Message-Id: <20080227101338.5089d72d.sfr@canb.auug.org.au>
In-Reply-To: <47C45749.3010001@s5r6.in-berlin.de>
References: <47C45749.3010001@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Feb_2008_10_13_38_+1100_p/s_4UlnAobZ110s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2008_10_13_38_+1100_p/s_4UlnAobZ110s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Tue, 26 Feb 2008 19:15:37 +0100 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> the allmodconfig builds at http://kisskb.ellerman.id.au/kisskb/branch/9/=
=20
> seem to lack a few drivers even though they are properly enabled in the=20
> respective config.  Is it simply because everything is rebuilt on top of=
=20
> a previous build?

That's interesting.  I thought they were built from a clean tree each
time but I will discuss this with Michael Ellerman who created this build
system.

> Do you mail only errors to maintainers or also compiler warnings?

Currently I am only concerned with actual failures.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Feb_2008_10_13_38_+1100_p/s_4UlnAobZ110s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHxJ0mTgG2atn1QN8RAmZDAJoDIyh4OBnVKvAvgXsN1ddJh7jyTgCdE4PO
ukEDSn3G1sp66qhLQq1xZMs=
=qE47
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2008_10_13_38_+1100_p/s_4UlnAobZ110s--
