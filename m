Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbZLQCIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbZLQCIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZLQCIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:08:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58987 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762945AbZLQCIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:08:11 -0500
Date: Thu, 17 Dec 2009 13:07:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20091217130758.edfe0da6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Dec_2009_13_07_58_+1100_0XlTj=OCYtCPry9W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Dec_2009_13_07_58_+1100_0XlTj=OCYtCPry9W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
kernel/perf_event.c between commit
0f624e7e5625f4c30c836b7a5decfe2553582391 ("perf_event: Fix incorrect
range check on cpu number") from Linus' tree and commit
40b7c6b7eefc950d625945f773b4c57dcc95b8a4
("cpumask:kernel_perf_event-deprecated-function") from the rr tree.

Overlapping changes.  I used the version from Linus' tree (since it was a
bug fix).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Dec_2009_13_07_58_+1100_0XlTj=OCYtCPry9W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkspkn4ACgkQjjKRsyhoI8xmkgCgsAqhHDnmwZQa6ZmPZ3rRjV9P
4foAniaU8zbnOIkaj93FDXyhXPqui9Pw
=zqqz
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Dec_2009_13_07_58_+1100_0XlTj=OCYtCPry9W--
