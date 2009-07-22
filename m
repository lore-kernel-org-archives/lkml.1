Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZGVXKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZGVXKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZGVXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:10:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZGVXKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:10:00 -0400
Date: Thu, 23 Jul 2009 09:09:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next:  kgdb tree fetch failure
Message-Id: <20090723090956.e6024af4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_09_09_56_+1000_=du3RAedLLhEINwp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_09_09_56_+1000_=du3RAedLLhEINwp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next fetch of the kgdb tree failed like this:

kgdb: git
fatal: Couldn't find remote ref refs/heads/kgdb-next
fatal: The remote end hung up unexpectedly

So I will use the kgdb tree from yesterday (which actually dates from
May).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jul_2009_09_09_56_+1000_=du3RAedLLhEINwp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpnnEQACgkQjjKRsyhoI8yD0gCgl8Tsv41lrm2w/VamuWxTwcbz
EQwAnjiXTF9v/Dy6gvc39LA+msIvMHMq
=+On5
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_09_09_56_+1000_=du3RAedLLhEINwp--
