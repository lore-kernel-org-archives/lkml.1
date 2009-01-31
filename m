Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZAaQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZAaQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZAaQf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:35:29 -0500
Received: from mx33.mail.ru ([194.67.23.194]:12478 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZAaQf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:35:29 -0500
X-Greylist: delayed 2120 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 11:35:28 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: netdev@vger.kernel.org
Subject: Some macro like dev_{info,...} for net devices?
Date: Sat, 31 Jan 2009 19:35:23 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2890119.1EcVWAaz8V";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901311935.24628.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2890119.1EcVWAaz8V
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Is there some printk macros like dev_info etc for standard log=20
formatting of bet devices?

TIA

=2Dandrey

--nextPart2890119.1EcVWAaz8V
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmEfcwACgkQR6LMutpd94wM5QCeI/6ahtOXrlu1xXvYnq2PGeyq
nr8An1/A6J4D9gO6h6p9A4kmJ4nR8vCx
=e6t+
-----END PGP SIGNATURE-----

--nextPart2890119.1EcVWAaz8V--
