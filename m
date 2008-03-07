Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbYCGAcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbYCGAcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbYCGAb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:31:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50672 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbYCGAb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:31:57 -0500
Date: Fri, 7 Mar 2008 11:31:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: dan.j.williams@intel.com, shannon.nelson@intel.com,
       linuxppc-dev@ozlabs.org, pasemi-linux@ozlabs.org,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA
 engine
Message-Id: <20080307113150.c0874344.sfr@canb.auug.org.au>
In-Reply-To: <20080306233900.GA3969@lixom.net>
References: <20080306233900.GA3969@lixom.net>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Mar_2008_11_31_50_+1100_oaTFoPpUPFtrVWSm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2008_11_31_50_+1100_oaTFoPpUPFtrVWSm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

Just one thing I noticed ...

On Thu, 6 Mar 2008 17:39:00 -0600 Olof Johansson <olof@lixom.net> wrote:
>
> +	dma_dev->device_dependency_added =3D pasemi_dma_dependency_added;

device_dependency_added is going away in 2.6.26 ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Mar_2008_11_31_50_+1100_oaTFoPpUPFtrVWSm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH0Iz6TgG2atn1QN8RAnm9AJ9Untb2ftwcbu9xkD/9HSVkAaFfPQCfemLP
gWkqeNeF4p/QbQk/X9Bh6n0=
=CBww
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2008_11_31_50_+1100_oaTFoPpUPFtrVWSm--
