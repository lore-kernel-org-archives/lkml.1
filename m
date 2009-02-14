Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZBNMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZBNMwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 07:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZBNMwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 07:52:38 -0500
Received: from zucker.schokokeks.org ([78.46.69.5]:37334 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZBNMwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 07:52:38 -0500
From: Hanno =?utf-8?q?B=C3=B6ck?= <hanno@hboeck.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
Date: Sat, 14 Feb 2009 13:52:24 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com>
In-Reply-To: <499584FC.2050104@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1624019.8K85oox94r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902141352.24277.hanno@hboeck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1624019.8K85oox94r
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Freitag 13 Februar 2009 schrieb Robert Hancock:
> That would be worth investigating, yes.. If you can provide the dmesg
> output from bootup, as well as the output of hdparm --Istdout on the
> disk device, that would be useful..

That (and a bit more, normal hdparm output, smartctl output) here:
http://files.hboeck.de/conner/

(please forward to potentially interested lists)

=2D-=20
Hanno B=C3=B6ck		Blog:		http://www.hboeck.de/
GPG: 3DBD3B20		Jabber/Mail:	hanno@hboeck.de

--nextPart1624019.8K85oox94r
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmWvogACgkQr2QksT29OyClfQCfdZEhB7Kc7d9KXgkAwuFNiVFV
QWwAn2b7TdGV4pAU9ngrTZaVlGAnlgpz
=mgm4
-----END PGP SIGNATURE-----

--nextPart1624019.8K85oox94r--
