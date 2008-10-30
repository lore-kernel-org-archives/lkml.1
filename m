Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYJ3VFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYJ3VFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYJ3VFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:05:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:42421 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYJ3VFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:05:07 -0400
Date: Thu, 30 Oct 2008 17:05:01 -0400
From: "Michael B. Trausch" <mike@trausch.us>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc2: System doesn't restart
Message-ID: <20081030170501.2858257c@zest>
In-Reply-To: <fa.1oHalgNC16O+xOrATo6drDAg6ls@ifi.uio.no>
References: <fa.1oHalgNC16O+xOrATo6drDAg6ls@ifi.uio.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LU2ovhopSshOkFTjbldLNzB";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LU2ovhopSshOkFTjbldLNzB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Oct 2008 20:35:43 UTC
Thomas Meyer <thomas@m3y3r.de> wrote:

> Hi,
>=20
> My system doesn't restart anymore with 2.6.28-rc2.
>=20
> Most times I get is:
> Restarting system
>=20
> Then the system seems to wait forever...
>=20
> But sometimes I get:
> Restarting system
> machine restart
> ACPI MEMORY or I/O RESET_REG
>=20

A silly question for you; does your system reboot when using a stock
Ubuntu kernel from the Ubuntu Live CD?

I ask this because I have this issue with my system and 2.6.28-rc2,
though Ubuntu has some patch or another that I haven't yet isolated
that makes my system reboot properly.  Using 2.6.28-rc2, I just see the
kernel message "[xxxxxx.xxxxxx] Restaring system", and have to use my
power button or reset button, for the moment.

It looks like your kernel is a 32-bit x86 build; I am having an issue
on x86-64 (specifically, an AMD64 system).

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/LU2ovhopSshOkFTjbldLNzB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkKIX4ACgkQ0kE/IBnFmjAXYwCgiAp9XZ3gQdw4LdlSWuVPwr9E
dSIAniMVtqouLCb82ie+3S3y0WRByvQ6
=g11Q
-----END PGP SIGNATURE-----

--Sig_/LU2ovhopSshOkFTjbldLNzB--
