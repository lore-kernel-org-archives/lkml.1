Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYCDKMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYCDKMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYCDKMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:12:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34452 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYCDKMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:12:31 -0500
Date: Tue, 4 Mar 2008 21:12:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: mporter@kernel.crashing.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] Add OF-tree support to RapidIO controller driver.
Message-Id: <20080304211223.873c190e.sfr@canb.auug.org.au>
In-Reply-To: <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Mar_2008_21_12_23_+1100_CxM+Y.N+ucXXoHxm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2008_21_12_23_+1100_CxM+Y.N+ucXXoHxm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed,  5 Mar 2008 00:29:50 +0800 Zhang Wei <wei.zhang@freescale.com> wrot=
e:
>
> +static struct of_device_id fsl_of_rio_rpn_ids[] =3D {

const, please.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Mar_2008_21_12_23_+1100_CxM+Y.N+ucXXoHxm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzSCMTgG2atn1QN8RAmxZAJ0eTNyAKpymSaqFrxY3Qc0Bobo2bgCeJARt
AEFhXgvOPfYvI6ENapgj0YU=
=wVRw
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2008_21_12_23_+1100_CxM+Y.N+ucXXoHxm--
