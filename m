Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbZJEDlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbZJEDlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbZJEDlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:41:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59795 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758435AbZJEDlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:41:49 -0400
Date: Mon, 5 Oct 2009 14:41:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: linux-next: manual merge of the device-mapper tree with Linus' tree
Message-Id: <20091005144102.8c012c56.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_14_41_02_+1100_4Tk9p2tgBm0snath"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_14_41_02_+1100_4Tk9p2tgBm0snath
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Today's linux-next merge of the device-mapper tree got a conflict in
drivers/md/dm-log-userspace-transfer.c between commit
18366b05a00349c1606269ba7422bf9b3a357ff2 ("connector/dm: Fixed a
compilation warning") from Linus' tree and commit
584ac98acfc033dfda338641e736b0100fd31909
("dm-log-fix-cn_ulog_callback-declaration") from the device-mapper tree.

The former commit (already in Linus' tree) supersedes the latter, so I
used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Oct_2009_14_41_02_+1100_4Tk9p2tgBm0snath
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJas4ACgkQjjKRsyhoI8zoewCgumpHBqRIzCwORCC6gtq1fztw
PiYAni4uCQsEJOgErgK5jhWIxXnHXzF0
=Ml5h
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_14_41_02_+1100_4Tk9p2tgBm0snath--
