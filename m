Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZJLJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZJLJfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZJLJfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:35:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZJLJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:35:03 -0400
Date: Mon, 12 Oct 2009 11:34:24 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gregkh@suse.de,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: fix controller printk format warnings
Message-ID: <20091012093424.GA3327@pengutronix.de>
References: <4AD28B51.7020903@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <4AD28B51.7020903@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2009 at 06:50:09PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix new pcmcia printk format warnings:
> [This has now moved from linux-next to mainline.
> Originally sent 2009-SEP-17.]

My plan was to pick it for pcmcia-l2 and ask Greg to pull it next week (aft=
er
ELC-E) together with my follow-up patch. If this is not fast enough, just l=
et
me know someone else picked it and I'll handle my patch seperately.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrS+CAACgkQD27XaX1/VRvi9wCffQWffct9Y2YNmFFY8c4ue219
iCkAoLnM76uFIfLwoHA3Y7Jl7KLWE7E7
=SxFS
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
