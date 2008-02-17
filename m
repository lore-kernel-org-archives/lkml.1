Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYBQMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYBQMRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYBQMRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:17:05 -0500
Received: from mx34.mail.ru ([194.67.23.200]:34091 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYBQMRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:17:04 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: [2.6.25-rc2] stack trace immediately before rebooting/switching off
Date: Sun, 17 Feb 2008 15:16:53 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16951264.8oVMdnWgyJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802171516.57468.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16951264.8oVMdnWgyJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

In 2.6.25 I get stack trace immediately before system is switched off or
reboots. It is too fast to capture it on VGA; netconsole does not capture
it either - probably network is already shutdown at this point. I do
not have serial port on this system.

Any idea how could I capture it? Thank you.

The problem did not exist in 2.6.24 and below.=20

=2Dandrey

--nextPart16951264.8oVMdnWgyJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAke4JbYACgkQR6LMutpd94yaegCgvJ9Fod7JWKOPyYipWilorDbS
TmoAn1azicCmJctEeWZbHKhNjzHbL5O+
=L9R8
-----END PGP SIGNATURE-----

--nextPart16951264.8oVMdnWgyJ--
