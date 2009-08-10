Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZHJKAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZHJKAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZHJKAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:00:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38238 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZHJKAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:00:36 -0400
Date: Mon, 10 Aug 2009 20:00:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hwpoison merge for linux-next / 2.6.32
Message-Id: <20090810200025.a32000be.sfr@canb.auug.org.au>
In-Reply-To: <20090810095535.GB6838@basil.fritz.box>
References: <20090807084902.GA14309@basil.fritz.box>
	<20090810194528.a3bc0cbc.sfr@canb.auug.org.au>
	<20090810095535.GB6838@basil.fritz.box>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_20_00_25_+1000_8jR2dgp8iI3+l__Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_20_00_25_+1000_8jR2dgp8iI3+l__Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Mon, 10 Aug 2009 11:55:35 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
> > Basically, this should be just what you would send to Linus or in this
> > case, Ingo, (or ask him to fetch).  It is allowed to be rebased if you
>=20
> This is practially all generic MM or VFS code, nothing for Ingo.

Sorry, cut and paste error, it should have read:

Basically, this should be just what you would send to Linus (or ask him
to fetch).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_20_00_25_+1000_8jR2dgp8iI3+l__Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/77kACgkQjjKRsyhoI8zhAgCgtyKGsJakRrjNWxST8YVp9wJO
FMEAoJguoADADWFpak6nqDuWSt0Zdl4e
=Vypb
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_20_00_25_+1000_8jR2dgp8iI3+l__Y--
