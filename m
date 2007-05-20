Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXETLL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXETLL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXETLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:11:19 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:46492 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXETLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:11:18 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2007 07:11:17 EDT
Date: Sun, 20 May 2007 13:11:13 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: aeb@cwi.nl
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc (3)
Message-ID: <20070520111113.GE3253@aragorn.home.lxtec.de>
Mail-Followup-To: aeb@cwi.nl, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building the kernel with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:392: warning: ignoring return value of 'kobject_add',=
 declared with attribute warn_unused_result
fs/partitions/check.c:395: warning: ignoring return value of 'sysfs_create_=
link', declared with attribute warn_unused_result
fs/partitions/check.c:403: warning: ignoring return value of 'sysfs_create_=
file', declared with attribute warn_unused_result
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUCzR3Ig8bsVPf7ARAn3jAJ4sABgRjxSSHYqiqG5umxWKZSCw3wCeObJx
rxQqHMWU0TVgSK8QHIl5pqY=
=fyra
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
