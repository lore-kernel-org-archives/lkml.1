Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbYG3XmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbYG3XmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbYG3XlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:41:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60940 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761507AbYG3XlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:41:13 -0400
Date: Thu, 31 Jul 2008 09:41:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, bwalle@suse.de,
       greg@kroah.com, hugh@veritas.com, gregkh@suse.de,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       haveblue@us.ibm.com
Subject: Re: linux-next: Tree for July 29
Message-Id: <20080731094105.f6bec082.sfr@canb.auug.org.au>
In-Reply-To: <20080730130419.49986a25.akpm@linux-foundation.org>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<20080730090650.79a5a749@kopernikus.site>
	<20080730021947.def99edc.akpm@linux-foundation.org>
	<200807302127.42148.bzolnier@gmail.com>
	<20080730130419.49986a25.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Jul_2008_09_41_05_+1000_GEco1YiH2R8Iv.Q0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jul_2008_09_41_05_+1000_GEco1YiH2R8Iv.Q0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 30 Jul 2008 13:04:19 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The offending patch has just got itself turfed from linux-next so my
> fix now has nothing to fix.
>=20
> We'll see what happens!

I will put Dave's patch back with yours on top of it (hoping that Greg
will take your patch).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Jul_2008_09_41_05_+1000_GEco1YiH2R8Iv.Q0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiQ/BEACgkQjjKRsyhoI8xtewCfcdqdXTFqLyIH+kXkjoqz5784
CugAoIyT0KJMbvB7hoaZt7eKJyjrJf/s
=u4Lg
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jul_2008_09_41_05_+1000_GEco1YiH2R8Iv.Q0--
