Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZIVXI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZIVXI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZIVXI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:08:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33219 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZIVXIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:08:55 -0400
Date: Wed, 23 Sep 2009 09:08:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch md-current and md trees
Message-Id: <20090923090854.40f492df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Sep_2009_09_08_54_+1000_YIlHo8rx1pAKB6.o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Sep_2009_09_08_54_+1000_YIlHo8rx1pAKB6.o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next fetch of the md{,-curent} trees failed like this:

md-current: git
fatal: The remote end hung up unexpectedly

I will use the version that I have previously fetched.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Sep_2009_09_08_54_+1000_YIlHo8rx1pAKB6.o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq5WQYACgkQjjKRsyhoI8xJ/QCdFqKOkZxnjkDL7AdsBwAbiC0U
QuwAoJWLUHBfzyunSQ6nJqKamd1TZnRk
=bQwH
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Sep_2009_09_08_54_+1000_YIlHo8rx1pAKB6.o--
