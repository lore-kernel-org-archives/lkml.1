Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYACCyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYACCyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYACCyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:54:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36529 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYACCyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:54:13 -0500
Date: Thu, 3 Jan 2008 13:54:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       stable@kernel.org
Subject: Re: [patch] powerpc systbl.h broken
Message-Id: <20080103135401.bc5aae91.sfr@canb.auug.org.au>
In-Reply-To: <20080103131624.5a3e98e8.sfr@canb.auug.org.au>
References: <20080102141127.GA11870@clifford.at>
	<20080103131624.5a3e98e8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Jan_2008_13_54_01_+1100_gapl4j2FXiTTwpFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2008_13_54_01_+1100_gapl4j2FXiTTwpFF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Jan 2008 13:16:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> This has been fixed in the current (approaching 2.6.24) kernel.  It
> should be fixed in 2.6.23.xx, so I have cc'd this to
> stable@vger.kernel.org (and linuxppc-dev, of course).

Should have been stable@kernel.org. (where I have sent another copy of
the email)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Jan_2008_13_54_01_+1100_gapl4j2FXiTTwpFF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHfE5NTgG2atn1QN8RAoyIAJ9svXHmKhFgAthlX2Aunv6AzirXDgCfdNfG
Nca+soXeD8lsYDoiqLen9nE=
=OeJw
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2008_13_54_01_+1100_gapl4j2FXiTTwpFF--
