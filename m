Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZLIMwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZLIMwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 07:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZLIMwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 07:52:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428AbZLIMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 07:52:14 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20091209120334.4b7f2051@lxorguk.ukuu.org.uk>
References: <1260335742.4532.246.camel@localhost>
	 <20091209120334.4b7f2051@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zn3+4HGfXcKZ4D4WRYtf"
Date: Wed, 09 Dec 2009 12:52:18 +0000
Message-ID: <1260363138.4532.255.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 2/5] firmware/WHENCE: Correct filenames for ambassador,
 bnx2x, cxgb3
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zn3+4HGfXcKZ4D4WRYtf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-09 at 12:03 +0000, Alan Cox wrote:
> On Wed, 09 Dec 2009 05:15:42 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > Filenames should be the names of the installed binary files, without
> > the base directory.
>=20
> Disagree - the WHENCE file says where it comes from and if it originally
> came in a hex file then thats the origin.

Then submit a patch to change all the *other* entries.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-zn3+4HGfXcKZ4D4WRYtf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASx+dgee/yOyVhhEJAQI0TBAA1L8Ncn0wPNEakFBOHlqOKyb7GQrbtn1+
Iv6PE1afJZJrmj2XElgAVNFio8DbtD3YyQYBpEnRgHT8u79lJqaZVBiVnpKKRPX0
W3kpSteP+4hLHHL+ixFBO8er095Fye49VpBzVeSLVTO4VH9m1nn//pjGsXDnom0f
YA9QfSODCKUQCE45ta62YdQ8T8vrryS3vm0wJ9tQJLkwdC/YOaKHkikHczs8d4gF
dndTP1yZMwxjjq2qYPL3su2ir4m4pt3J+2EMpfaSDDOGr0BYaieFYUuVOC7pNKML
Gp3t7heXodBRYiBNtOptjKcLme2ao2pMp8onoLldWZ1e1a5NzOO9fLzJrQWfvyT1
/cblW5akse5LfOZdnrB1J3BW0bKpLiLhi7VJfQDvRuJM9cuoxxVd6ghE52zaWT5j
A8mpWU1+K835zQWq9buC6xoATflIpaaE/EEbxoMlpAfvxcmeQDdMmRnazY1qX/Kx
uHcIAuv4PIKh5Sbl4iBPbBPnMIAlxu+AA8hmkgSZFbUWP+ykl756hdH4NKMOYit8
LXHi58Y+w9GfLE2VgFNaHgE8IloC0q/WzeC9SAGrjVB+sbtXfTvV9g9f/LGvRLLv
qh3wTgxu7gvO8SGevtN4ir8CGkm9SrPnLAYCdj3xS3qmk2Vi8Ttfh0qJOencF2av
tDiaq1cDpRk=
=tLQd
-----END PGP SIGNATURE-----

--=-zn3+4HGfXcKZ4D4WRYtf--
