Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbYBXEoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbYBXEoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbYBXEoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:44:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51769 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbYBXEo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:44:29 -0500
Date: Sun, 24 Feb 2008 15:44:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ke Wei <kewei@marvell.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi/mvsas.c needs to include linux/ctype.h fo isalnum
Message-Id: <20080224154423.ff8c07e9.sfr@canb.auug.org.au>
In-Reply-To: <1203827951.3139.15.camel@localhost.localdomain>
References: <20080224152700.20365867.sfr@canb.auug.org.au>
	<1203827951.3139.15.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__24_Feb_2008_15_44_23_+1100_8Z7tJtGo_8iNcDdk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__24_Feb_2008_15_44_23_+1100_8Z7tJtGo_8iNcDdk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Feb 2008 22:39:11 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> In future, it would be nice if you could send SCSI patches to the SCSI
> list: linux-scsi@vger.kernel.org

Sure thing.

> But actually, a more complete version of this one is already upstream as
> commit 0a3716eb04ccfdbef6e872a343ba7ce309237e79

Excellent.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__24_Feb_2008_15_44_23_+1100_8Z7tJtGo_8iNcDdk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwPYsTgG2atn1QN8RAqaOAJ9QUx98X5ZvieXzdjuQFUMXZUlvtgCfQNwQ
1+ODaGDzX0VfnY4U9SkyoOQ=
=IGn7
-----END PGP SIGNATURE-----

--Signature=_Sun__24_Feb_2008_15_44_23_+1100_8Z7tJtGo_8iNcDdk--
