Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbXHOHIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbXHOHIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXHOHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:08:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXHOHIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:08:14 -0400
Date: Wed, 15 Aug 2007 17:08:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] allow disabling DNOTIFY without EMBEDDED
Message-Id: <20070815170807.aacdf871.sfr@canb.auug.org.au>
In-Reply-To: <20070814212712.GC18945@stusta.de>
References: <20070814212712.GC18945@stusta.de>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Aug_2007_17_08_07_+1000_c5UGL7tP/yPuLsLe"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Aug_2007_17_08_07_+1000_c5UGL7tP/yPuLsLe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Aug 2007 23:27:12 +0200 Adrian Bunk <bunk@kernel.org> wrote:
>
> This patch allows disabling DNOTIFY with CONFIG_EMBEDDED=3Dn.
>=20
> I'm currently running a kernel with dnotify disabled and I haven't run=20
> into any problem. Is there any popular application left that breaks=20
> without dnotify support in the kernel?
>=20
> Note that this patch does not remove dnotify support, it still defaults
> to "y", and the help text recommends enabling it.
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Aug_2007_17_08_07_+1000_c5UGL7tP/yPuLsLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwqZcTgG2atn1QN8RAu0kAJ9/kW388S+cOU34iKPwe1qfumbxyACgmjup
Vd1mEcBh719OpbTUF5j00Q4=
=v/It
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Aug_2007_17_08_07_+1000_c5UGL7tP/yPuLsLe--
