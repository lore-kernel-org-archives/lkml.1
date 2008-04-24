Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYDXJak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYDXJak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYDXJab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:30:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56247 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYDXJaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:30:30 -0400
Date: Thu, 24 Apr 2008 19:30:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24
Message-Id: <20080424193023.862cacd7.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Apr_2008_19_30_23_+1000_Fh5sq0q+Ff8W2Tb8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2008_19_30_23_+1000_Fh5sq0q+Ff8W2Tb8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Thu, 24 Apr 2008 09:45:57 +0200 (CEST) Geert Uytterhoeven <geert@linux-m=
68k.org> wrote:
>
> For m68k, I've added multi_defconfig, to build a kernel for all supported=
 m68k
> platforms, excluding Sun 3 (Sun 3 kernels are incompatible with all other=
 m68k
> platforms).
>=20
> Hence if you would build multi_defconfig and sun3_defconfig, you cover al=
l of
> our platforms and drivers.

Done.  Thanks.

> Alternatively, you can just build all defconfigs, but that's more work ;-)

:-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Apr_2008_19_30_23_+1000_Fh5sq0q+Ff8W2Tb8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIEFMzTgG2atn1QN8RAvJJAJkBJMuve/HfxMMiABBRyqrNVPjekwCfW/qY
vIxGUdZG3k2qBAVaFDxXYto=
=WFRf
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2008_19_30_23_+1000_Fh5sq0q+Ff8W2Tb8--
