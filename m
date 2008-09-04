Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYIDMvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYIDMvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIDMvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:51:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53821 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYIDMvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:51:44 -0400
Date: Thu, 4 Sep 2008 22:51:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for September 4
Message-Id: <20080904225127.2937905e.sfr@canb.auug.org.au>
In-Reply-To: <20080904125248.117e7cf9@lxorguk.ukuu.org.uk>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
	<20080904125248.117e7cf9@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Sep_2008_22_51_27_+1000_7xPW+bt/Uqxg1UZJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Sep_2008_22_51_27_+1000_7xPW+bt/Uqxg1UZJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Thu, 4 Sep 2008 12:52:48 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > I have reverted the ttydev tree for today at Andrew's request since it =
is
> > causing him a problem.
>=20
> I've pushed a "mini" ttydev tree with just the fixes and earlier patches
> in for the moment while I nail this one down. That way the stuff which
> is independent can still be tested and get to Linus even if the big tty
> rework has to be delayed.

Thanks, I will fetch that tomorrow.  (Aren't timezones fun? :-))

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Sep_2008_22_51_27_+1000_7xPW+bt/Uqxg1UZJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki/2c8ACgkQjjKRsyhoI8xuMACfXj5GQnikxXMoYEnTGwAxZMRx
ykkAnRbzP9KoPfMKlPcBUPZqCCo/sjYs
=meCT
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Sep_2008_22_51_27_+1000_7xPW+bt/Uqxg1UZJ--
