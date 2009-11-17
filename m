Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZKQEuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZKQEuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 23:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZKQEt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 23:49:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40363 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbZKQEt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 23:49:59 -0500
Date: Tue, 17 Nov 2009 15:49:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkFuZHLDqSBHb2RkYXJkIFJvc2Ei?= <andre.goddard@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the trivial tree with the wireless tree
Message-Id: <20091117154957.a23c959b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Nov_2009_15_49_57_+1100_9qGnQSJmCdXg3vuN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Nov_2009_15_49_57_+1100_9qGnQSJmCdXg3vuN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/wireless/rt2x00/rt2800usb.h between various commits from the
wireless tree and commit 17530b1c635dfd1f258afc6b07b986b425d66ebd
("tree-wide: fix assorted typos all over the place") from the trivial
tree.

The wireless tree commits moved the code fixed by the trivial tree, but
also fixed it along the way, so I have ignored the trivial fixup for this
file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Nov_2009_15_49_57_+1100_9qGnQSJmCdXg3vuN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksCK3UACgkQjjKRsyhoI8wcogCghl0szg/1hfhroyzsy1AxYnta
5mEAniWpu11yrOBOSYF/33b6epEh4So/
=hqHo
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Nov_2009_15_49_57_+1100_9qGnQSJmCdXg3vuN--
