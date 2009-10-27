Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZJ0EnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZJ0EnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZJ0EnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:43:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33131 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbZJ0EnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:43:20 -0400
Date: Tue, 27 Oct 2009 15:43:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ceph tree build warning
Message-Id: <20091027154313.1618c142.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Oct_2009_15_43_13_+1100_DmdgJooExra=c6X."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Oct_2009_15_43_13_+1100_DmdgJooExra=c6X.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

fs/ceph/super.c: In function 'parse_mount_args':
fs/ceph/super.c:473: warning: the frame size of 4320 bytes is larger than 2=
048 bytes

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Oct_2009_15_43_13_+1100_DmdgJooExra=c6X.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrmemEACgkQjjKRsyhoI8wgYgCfRukVTBM4dqGKazEqgexLoEKO
ytYAn0pQCOiQyyUAduSD/iIIoBtLrZLx
=ihDe
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Oct_2009_15_43_13_+1100_DmdgJooExra=c6X.--
