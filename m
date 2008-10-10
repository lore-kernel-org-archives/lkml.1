Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbYJJRP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbYJJRP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbYJJRPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:15:14 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:34238 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759921AbYJJRPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:15:13 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Fri, 10 Oct 2008 21:14:54 +0400
User-Agent: KMail/1.9.10
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <200810101141.38929.arvidjaar@newmail.ru> <48EF8AF4.1040900@gmail.com>
In-Reply-To: <48EF8AF4.1040900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1481268.soIThUeM6u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810102114.55663.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1481268.soIThUeM6u
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 10 October 2008, Dave wrote:
>=20
> You're right. pda_size is supposed to be the maximum size of the PDA (in =
bytes) that we expect with the firmware. It should be set to 0x200.
>=20

Do you want me to send a patch?

--nextPart1481268.soIThUeM6u
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjvjY8ACgkQR6LMutpd94x5MwCgtxGdCw6fRAOPtyap9zjxoY8K
sGIAn2dtmGcT5aiwT5nP//EDVqUgmrKg
=xT+R
-----END PGP SIGNATURE-----

--nextPart1481268.soIThUeM6u--
