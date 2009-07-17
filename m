Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbZGQC4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbZGQC4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934039AbZGQC4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:56:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54165 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbZGQC4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:56:38 -0400
Date: Fri, 17 Jul 2009 12:56:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build warning
Message-Id: <20090717125632.7c1296a6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jul_2009_12_56_32_+1000_CcgW+Cpq2gBDd2pU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jul_2009_12_56_32_+1000_CcgW+Cpq2gBDd2pU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/serial/serial_core.c: In function 'uart_block_til_ready':
drivers/serial/serial_core.c:1506: warning: unused variable 'uport'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jul_2009_12_56_32_+1000_CcgW+Cpq2gBDd2pU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpf6GAACgkQjjKRsyhoI8xOjQCeM38sPkFpA3EmI8FQHERqyAeu
r2IAn2luYAL6DmFu3c3fEClQGXnDb2mL
=wB4I
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jul_2009_12_56_32_+1000_CcgW+Cpq2gBDd2pU--
