Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYKUGk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYKUGk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 01:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYKUGkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 01:40:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59068 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYKUGkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 01:40:46 -0500
Date: Fri, 21 Nov 2008 17:40:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Holden <aciddeath@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unused variables from the cirrusfb driver
Message-Id: <20081121174027.f95bad9a.sfr@canb.auug.org.au>
In-Reply-To: <DE425C06-700A-4042-B0AB-1CDE2134C4DF@gmail.com>
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
	<1227204203-32112-2-git-send-email-aciddeath@gmail.com>
	<20081121103409.fed9a837.sfr@canb.auug.org.au>
	<DE425C06-700A-4042-B0AB-1CDE2134C4DF@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Nov_2008_17_40_27_+1100_WXyPubIGuJV0h/eC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Nov_2008_17_40_27_+1100_WXyPubIGuJV0h/eC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 20 Nov 2008 23:12:42 -0700 Richard Holden <aciddeath@gmail.com> wro=
te:
>
> Am I right in assuming you pulled mainline before this commit for =20
> next-20081120? I don't see the changelog in next and I'm getting the =20
> build warnings still, but I can recheck this in the next version of =20
> next.

Yes, I refetch all the trees before I begin building the tree each day.
That patch went to Linus yesterday so it will be in today's linux-next
when I release it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Nov_2008_17_40_27_+1100_WXyPubIGuJV0h/eC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkmV9sACgkQjjKRsyhoI8xFCACbBMbihhSlR1xfCl5hmWBKmbAN
WtEAoIELMyIrOCe62KsAh64Gx0UYcVcz
=Ffw3
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Nov_2008_17_40_27_+1100_WXyPubIGuJV0h/eC--
