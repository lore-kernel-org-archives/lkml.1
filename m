Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXGRDmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXGRDmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGRDmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:42:45 -0400
Received: from mx5.mail.ru ([194.67.23.25]:34216 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXGRDmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:42:45 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: CONFIG_IDE_PROC_FS: /sys is not full replacement of /proc
Date: Wed, 18 Jul 2007 07:42:42 +0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2005426.dapETvmZ8g";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707180742.42651.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2005426.dapETvmZ8g
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

May be I miss something obvious but most information that was available=20
in /proc/ide is missing under /sys. At the very least, Mandriva hardware=20
detection expects /proc/ide/hdX/model; nothing close is under /sys.

Are there any plans to extend IDE /sys interface to provide full range of=20
information from /proc? Alternatively I appreciate description (or pointer =
to=20
thereof) how to get information that was available under /proc/ide=20
without /proc/ide :)

Thank you

=2Dandrey

--nextPart2005426.dapETvmZ8g
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGnYwyR6LMutpd94wRAtYtAKCJRXb8rYaCKfBHEmrXwFJEHZsW8gCgk4Ml
srdU7JrSM6B5UzMG2AJqL0I=
=sog+
-----END PGP SIGNATURE-----

--nextPart2005426.dapETvmZ8g--
