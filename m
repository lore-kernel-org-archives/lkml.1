Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYDWX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYDWX7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYDWX7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:59:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43499 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYDWX7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:59:43 -0400
Date: Thu, 24 Apr 2008 09:59:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: optimized inlining
Message-Id: <20080424095932.70c87714.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Apr_2008_09_59_32_+1000_hFWy.xp+hPwKDV31"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2008_09_59_32_+1000_hFWy.xp+hPwKDV31
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

Could you please merge your two patches "x86: add optimized inlining" and
"generic: optimized inlining, fix" before you send them to Linus.  This
way we won't have another bad spot to land while bisecting on powerpc.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Apr_2008_09_59_32_+1000_hFWy.xp+hPwKDV31
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFID81pTgG2atn1QN8RAnj9AJ4rMzIgV0OjCxHT4T+zUPQVlXmYsgCgl+iq
Tlucx0WKtZQ1FBf1PurXHLc=
=zBUz
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2008_09_59_32_+1000_hFWy.xp+hPwKDV31--
