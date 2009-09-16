Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbZIPNRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbZIPNRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZIPNRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:17:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34544 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZIPNRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:17:40 -0400
Date: Wed, 16 Sep 2009 23:17:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.32 -mm Blackfin patches
Message-Id: <20090916231735.50c6a742.sfr@canb.auug.org.au>
In-Reply-To: <8bd0f97a0909160553r4dae0eb7j345dea2a68fa4310@mail.gmail.com>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com>
	<20090915211810.d1b83015.akpm@linux-foundation.org>
	<8bd0f97a0909152124n186278feja97a7257548b3eb7@mail.gmail.com>
	<20090916160651.88b10377.sfr@canb.auug.org.au>
	<8bd0f97a0909160553r4dae0eb7j345dea2a68fa4310@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Sep_2009_23_17_35_+1000_TySD/VF5g95ZaKAo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Sep_2009_23_17_35_+1000_TySD/VF5g95ZaKAo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Wed, 16 Sep 2009 08:53:46 -0400 Mike Frysinger <vapier.adi@gmail.com> wr=
ote:
>
> ok, please replace the current Blackfin tree:
>     git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.g=
it#for-linus
> with my Blackfin tree:
>     git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git#for=
-linus
>=20
> and i'll try to keep it updated

Done. It will be in tomorrow's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Sep_2009_23_17_35_+1000_TySD/VF5g95ZaKAo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqw5W8ACgkQjjKRsyhoI8zhdwCfag52Bv1/Iw/ys7hnDOfaKvpa
EAcAniLwOpmF2mvY/GZPmdhBBuf+ZCGz
=aiG3
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Sep_2009_23_17_35_+1000_TySD/VF5g95ZaKAo--
