Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXETL1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXETL1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXETL1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:27:31 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:36260 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbXETL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:27:30 -0400
Date: Sun, 20 May 2007 13:27:25 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: bfennema@falcon.csc.calpoly.edu
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc
Message-ID: <20070520112725.GL3253@aragorn.home.lxtec.de>
Mail-Followup-To: bfennema@falcon.csc.calpoly.edu,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mit9XoPEfICDqq/V"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Mit9XoPEfICDqq/V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building the kernel modules with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
fs/udf/balloc.c: In function 'udf_table_new_block':
fs/udf/balloc.c:747: warning: 'goal_eloc.logicalBlockNum' may be used unini=
tialized in this function
fs/udf/super.c: In function 'udf_fill_super':
fs/udf/super.c:1359: warning: 'ino.partitionReferenceNum' may be used unini=
tialized in this function
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--Mit9XoPEfICDqq/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUDCd3Ig8bsVPf7ARAsJdAKCdZNwLD2W1HxGYGyOwuTMLWnvbywCeI+/j
UnWVzsCYWnMGQPmN5XAsxS4=
=XKh6
-----END PGP SIGNATURE-----

--Mit9XoPEfICDqq/V--
