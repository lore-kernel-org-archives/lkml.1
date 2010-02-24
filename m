Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0BXCnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:43:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49822 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0BXCnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:43:46 -0500
Date: Wed, 24 Feb 2010 13:43:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the nfsd and xfs trees
Message-Id: <20100224134339.da65a976.sfr@canb.auug.org.au>
In-Reply-To: <20100224015848.GE16175@discord.disaster>
References: <20100224123646.bb62faea.sfr@canb.auug.org.au>
	<20100224015848.GE16175@discord.disaster>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Feb_2010_13_43_39_+1100_dXiEvDZDf2fitGOq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Feb_2010_13_43_39_+1100_dXiEvDZDf2fitGOq
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 24 Feb 2010 12:58:48 +1100 Dave Chinner <david@fromorbit.com> wrote:
>
> I was waiting for this email to come in. ;)

:-)

> Yes, that is the correct fix. Thanks for that, Stephen. Consider it:
>=20
> Reviewed-by: Dave Chinner <david@fromorbit.com>

Thanks for the confirmation.

> =D0=86t would be good if you could keep it as a merge fixup - we don't
> really want to have to pull the -next NFS tree into the XFS tree or vice
> versa until one or the other is upstream....

Yep, no problem (I have a system that does that for me).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Feb_2010_13_43_39_+1100_dXiEvDZDf2fitGOq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuEklsACgkQjjKRsyhoI8y16wCbBKObzmWg9DvFocZcJQmGgL49
VKQAmgLvym+88Sbvub34GQ1Xpi1/e5lE
=dYzf
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Feb_2010_13_43_39_+1100_dXiEvDZDf2fitGOq--
