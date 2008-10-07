Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYJGQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYJGQ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYJGQ6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:58:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYJGQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:57:59 -0400
Subject: Re: bad DMAR interaction with iwlagn and SATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Andres Freund <andres@anarazel.de>
Cc: Tomas Winkler <tomasw@gmail.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810061632.08375.andres@anarazel.de>
References: <200809251511.20132.andres@anarazel.de>
	 <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com>
	 <1223296015.15196.2.camel@johannes.berg>
	 <200810061632.08375.andres@anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K3ZPc9bUTYTfBoiC7mQC"
Date: Tue, 07 Oct 2008 10:37:16 +0200
Message-Id: <1223368636.3778.64.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K3ZPc9bUTYTfBoiC7mQC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 16:32 +0200, Andres Freund wrote:

> > Andres, can you post your config?
> Sure, my current running one is attached.
> The config I had the error with was exactly the same just with CONFIG_DMA=
R and=20
> e1000e enabled (but is overwritten now)...
>=20
> Its no problem trying another branch more debugging options or so if need=
ed.

No, I was just wondering whether x86-64 had something like powerpc's
CONFIG_64K_PAGES, but it doesn't seem to. 2M-page support seems to be
used always dependent on the CPU, but I have no idea you can tell
whether or not your CPU supports that.

johannes

--=-K3ZPc9bUTYTfBoiC7mQC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6x+3AAoJEKVg1VMiehFYrQMP/iTQbpDUX4VjvSpbJEaP2pRR
gH4BGI/D03f/S3SotZGRwgIShbqNkEV140c9GXUtcsm13UA8B09IaIe93zlwbH2i
UWYVizZTkQWboQHjVPVr8+5g0Qj5y3s9UL0+JnLvIYdD79JEmhRP8DCqOuF5u4Bx
AOf3jQFPB7jL3cTz7nQ3fjyiM3DhUROOu+V1KAbKxdPZ+7sqC99lknKw268qXSTN
XCoAhtpU9z6IaKERGCva4w1nW+i1qZv5uzjBaXD1e68YXLk+s//vXq4VL6TyzLzw
CTjieWtRhqk5eLOUGgGVWo9zWCeOLF4aVfEdcVpCPZmg5NOvBgoybH1EdYsJWFNK
88kYsdkdUSyQ+s7djlnBPX22Za5OJj7a9UppJlS8RdI8zDL55uhhu+JbZsaML6td
XG4ig4SeBT4FzO4joKG5sf5kx7Nxwf1EIWELq4YPi0pMoDnS0S7KntzfhNSmjb6a
kXunb3U2Im4YbCh4qW2Ix1kyThRCu+nx4jACR1iZt+B3cDMIIdSZcZSe3kMV26z7
d/fV4Yi/50pfrol7CZHhiYxK8K+rWexnxD4V0oJ0jnu6h2aYo0ySb6MKzejb7ReJ
9nAnKMq9cZ0OaoufkHxXMRoGWeqswtjLfcsaIbKnPJOeDU4d6bEiaqDcPanKl3kS
kBGBwDi6AgG1FFDXJE40
=E0vl
-----END PGP SIGNATURE-----

--=-K3ZPc9bUTYTfBoiC7mQC--

