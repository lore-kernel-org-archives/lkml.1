Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0CIWu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:50:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43981 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CIWuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:50:25 -0500
Date: Wed, 10 Mar 2010 09:50:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: fetch of edac-amd tree failed
Message-Id: <20100310095013.2766db19.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Mar_2010_09_50_13_+1100_VAhAOw4HmQjRoJm8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Mar_2010_09_50_13_+1100_VAhAOw4HmQjRoJm8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

The linux-next fetch of the edac-amd tree has been failing like this for
a few days:

fatal: Couldn't find remote ref refs/heads/for-next

I am still using the version from next-20100212 (which has been merged
into Linus' tree).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Mar_2010_09_50_13_+1100_VAhAOw4HmQjRoJm8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuW0KUACgkQjjKRsyhoI8y0awCeM3+typ8IWLiYRje7QoCL/RnM
mVYAoJIlhRWjQ7OlxBrUxCp3fl3BRA68
=F3wH
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Mar_2010_09_50_13_+1100_VAhAOw4HmQjRoJm8--
