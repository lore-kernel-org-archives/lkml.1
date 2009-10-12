Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbZJLXFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbZJLXFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbZJLXFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:05:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32803 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568AbZJLXFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:05:05 -0400
Date: Tue, 13 Oct 2009 10:04:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Teigland <teigland@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: unable to fetch dlm tree
Message-Id: <20091013100423.6afbb070.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_10_04_23_+1100_l5eBvhdEQdZPBmOO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_10_04_23_+1100_l5eBvhdEQdZPBmOO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Fetching the dlm tree for today's linux-next gives me

fatal: Couldn't find remote ref refs/heads/next

and, indeed, "git ls-remote" shows no "next" branch.

I will use the dlm tree from yesterday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_10_04_23_+1100_l5eBvhdEQdZPBmOO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrTtfcACgkQjjKRsyhoI8zTEACgnaZ5oHibSCB7boZYrTKrpWJn
0JsAoIsia5sf1814zLzUH/ckZvURDnWc
=k4Ei
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_10_04_23_+1100_l5eBvhdEQdZPBmOO--
