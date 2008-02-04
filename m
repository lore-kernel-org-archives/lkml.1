Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYBDTSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYBDTSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbYBDTSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:18:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:43217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757583AbYBDTSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:18:13 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18nEagfrvsnCSoS/WrTdY15tY/coGdKn/wsyJlHuJ
	cmCRLV/CFSMBx6
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Mon, 4 Feb 2008 20:18:04 +0100
User-Agent: KMail/1.9.7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cpufreq@www.linux.org.uk
References: <200801261506.28544.toralf.foerster@gmx.de> <20080203163255.467256d4.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE7830C7@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE7830C7@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1419441.xcOoMoaQrd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802042018.09172.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1419441.xcOoMoaQrd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Monday 04 February 2008 Pallipadi, Venkatesh wrote :
>=20
> This looks like is related to the report here
> http://www.ussg.iu.edu/hypermail/linux/kernel/0801.3/1260.html
>=20
> Can you try the workarounds on that thread and see whether the problem go=
es away.
>=20
Yes, I already answered here :

http://lkml.org/lkml/2008/1/28/195

:-)
=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1419441.xcOoMoaQrd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHp2TxhyrlCH22naMRAvqNAJ94cZH03xwAmmQAMdLP8oWaze4JSwCgsBKX
CKsQDrmnBG8Z6cyxbvyM54s=
=l17p
-----END PGP SIGNATURE-----

--nextPart1419441.xcOoMoaQrd--
