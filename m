Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXETLWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXETLWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXETLWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:22:05 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:33654 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXETLWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:22:04 -0400
Date: Sun, 20 May 2007 13:21:58 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc (4)
Message-ID: <20070520112158.GI3253@aragorn.home.lxtec.de>
Mail-Followup-To: benh@kernel.crashing.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building the kernel with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
drivers/video/aty/radeon_base.c:2326: warning: ignoring return value of 'sy=
sfs_create_bin_file', declared with attribute warn_unused_result
drivers/video/aty/radeon_base.c:2328: warning: ignoring return value of 'sy=
sfs_create_bin_file', declared with attribute warn_unused_result
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUC9V3Ig8bsVPf7ARAsdhAJ9nE4lgF01kZiGoL+886PZLWg8MrwCeLmrP
gLG0GkPARAJI2Its8uJiEjY=
=vLMm
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
