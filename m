Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYKCNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYKCNBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYKCNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:01:07 -0500
Received: from mx33.mail.ru ([194.67.23.194]:32679 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbYKCNBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:01:06 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28 regression? LCD display inactive after reboot on Toshiba Portege 4000
Date: Mon, 3 Nov 2008 16:00:59 +0300
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5841872.8BJaPcJVDv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811031600.59968.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5841872.8BJaPcJVDv
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I had this every now and then before but right now I consistently
have the issue after reboot under 2.6.28-rc2 and emergency reboot
(SysRq-B) under rc3 (emergency because I cannot get past creating
devices in initrd - it just hangs there).

After reboot display is empty; I have to use hot key (Fn-F5 in this
case to reactivate LCD again).

As I said the problem was always there, just happened very infrequently.
I am use BIOD reboot method because ACPI leaves keyboard disabled.

Any idea?

--nextPart5841872.8BJaPcJVDv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkO9gsACgkQR6LMutpd94wWLwCfT0jiVqHn1eyse7IcU9LP5oAv
oSUAniZvUx5fMsbM6JFJaYnLl9rTAeqj
=ojYc
-----END PGP SIGNATURE-----

--nextPart5841872.8BJaPcJVDv--
