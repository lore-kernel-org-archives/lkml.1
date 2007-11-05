Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbXKETCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbXKETCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXKETCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:02:37 -0500
Received: from mx27.mail.ru ([194.67.23.23]:19002 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXKETCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:02:37 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc1:  hibernation hung on "Suspending console"
Date: Mon, 5 Nov 2007 22:01:16 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4443979.kdgH70WP16";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711052201.17150.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4443979.kdgH70WP16
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Notice "hung" not "hangs". This happened so far only once - when low batter=
y=20
condition triggered suspend to disk. I was not able to reproduce it after=20
this running on AC.

Just in case it rings the bell for someone. This is not suspend regression=
=20
reported earlier by Jens - I do not even have SATA nor is using libata=20
drivers.

=2Dandrey

--nextPart4443979.kdgH70WP16
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHL2h9R6LMutpd94wRAgZPAJ9ZUbErjx5OlNhbDw8t/JCchnc5dACeL0xB
+VVJpzGNIKWlIMcqY3yEzIg=
=OPJa
-----END PGP SIGNATURE-----

--nextPart4443979.kdgH70WP16--
