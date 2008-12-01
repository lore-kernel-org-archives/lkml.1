Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYLADcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYLADcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 22:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYLADce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 22:32:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60713 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYLADce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 22:32:34 -0500
Date: Mon, 1 Dec 2008 14:32:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, gregkh@suse.de
Subject: Re: mmotm 2008-11-29-01-53 uploaded
Message-Id: <20081201143212.ff4e7079.sfr@canb.auug.org.au>
In-Reply-To: <20081130191124.e16de170.akpm@linux-foundation.org>
References: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org>
	<20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
	<20081130191124.e16de170.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Dec_2008_14_32_12_+1100_I.nCelyPu=eeVyJ5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Dec_2008_14_32_12_+1100_I.nCelyPu=eeVyJ5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Sun, 30 Nov 2008 19:11:24 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Thanks, that'll be
>=20
> commit 9b473de87209fa86eb421b23386693b461612f30
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Oct 22 10:00:22 2008 -0500
>=20
>     param: Fix duplicate module prefixes
>=20
> I assume.  Rusty's been on the schnapps again ;)

Indeed! :-) However it was fixed for next-20081128.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Dec_2008_14_32_12_+1100_I.nCelyPu=eeVyJ5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkzWrwACgkQjjKRsyhoI8zyLwCfW7vH87Nuu5qkmII0vugyTRwE
u2QAnRf98NFD8OohkmiU65v6PDTPk4vx
=/94D
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Dec_2008_14_32_12_+1100_I.nCelyPu=eeVyJ5--
