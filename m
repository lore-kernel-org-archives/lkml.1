Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZDMGL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZDMGL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZDMGLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:11:20 -0400
Received: from nn7.de ([85.214.94.156]:34161 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMGLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:11:19 -0400
Subject: Uhhuh. NMI received for unknown reason b0 on CPU 0.
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V6gP54eFEQXxhZ9OcM0X"
Date: Sat, 11 Apr 2009 08:16:24 +0200
Message-Id: <1239430584.10277.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V6gP54eFEQXxhZ9OcM0X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dear all,

I just got this error on a samsung nc 10 netbook running 2.6.29.1:

Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
s3 kernel: Uhhuh. NMI received for unknown reason b0 on CPU 0.

Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
s3 kernel: You have some hardware problem, likely on the PCI bus.

Message from syslogd@x at Fri Apr 10 16:31:48 2009 ...
s3 kernel: Dazed and confused, but trying to continue

The thing operates as normal but leaves me (and the kernel!) confused?!

Should I be worried?
Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-V6gP54eFEQXxhZ9OcM0X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkngNbEACgkQ/h9eL9HisW+guACgipAjkfAqoiwori8qw6a3Bikw
0TUAnjDSzm5dSfbw13EqVN0V5BnxdJ2v
=41wH
-----END PGP SIGNATURE-----

--=-V6gP54eFEQXxhZ9OcM0X--
