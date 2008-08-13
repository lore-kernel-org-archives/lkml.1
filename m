Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHMX6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHMX6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHMX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:58:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53239 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYHMX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:58:06 -0400
Date: Thu, 14 Aug 2008 09:57:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tree for linux-next
Message-Id: <20080814095756.a0152a27.sfr@canb.auug.org.au>
In-Reply-To: <20080813161654.GA19599@doriath.ww600.siemens.net>
References: <20080813161654.GA19599@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Aug_2008_09_57_56_+1000_=bso=ZRoM+rdwhZI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Aug_2008_09_57_56_+1000_=bso=ZRoM+rdwhZI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Wed, 13 Aug 2008 20:16:55 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> =
wrote:
>
> Please add a tree to linux-next. It contains some cleanup for Sharp
> Zaurus PDA's. Since it contains a number of patches, it's preferable
> to test it via linux-next, before commiting to Russell's/ALSA tree.

I assume you have already posted these changes somewhere and had them
reviewed and unit tested them, right?

> The url to pull is git://github.com/lumag/linux-2.6.git#for-next

$ git ls-remote git://github.com/lumag/linux-2.6.git
fatal: protocol error: expected sha/ref, got '
*********'

Permission denied. Repository is not public.

*********'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Aug_2008_09_57_56_+1000_=bso=ZRoM+rdwhZI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkijdQQACgkQjjKRsyhoI8w6EACfenZIr5CLYLo4jV1BX3DTWCXQ
o00AoK2/234Dy68Fd06+gksT8DiTdJAi
=LI6W
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Aug_2008_09_57_56_+1000_=bso=ZRoM+rdwhZI--
