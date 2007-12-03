Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbXLCRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbXLCRVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXLCRVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:21:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:56887 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751143AbXLCRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:21:45 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Nr9YAcp4NUzM5JbchaTT+1uChi0vayfziBiqRNi
	2x/xr6mzoRRUFG
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Date: Mon, 3 Dec 2007 18:21:38 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200712031419.41596.toralf.foerster@gmx.de> <47540950.4090207@gentoo.org>
In-Reply-To: <47540950.4090207@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4720624.bDgyU2f7Tv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712031821.41550.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4720624.bDgyU2f7Tv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hhm,

in general it seems to be a regression of kernel 2.6.23 with suspend/hibern=
ate
if a user mode linux image is runnning.

With previous kernel versions (tested gentoo-sources-2.6.22-r9 and=20
gentoo-sources-2.6.21-r4) I've no problem to either suspend or to hibernate=
 the
ThinkPad T41.

However with gentoo-sources-2.6.23-r3 the system didn't neither
suspend nor hibernate. The good news is that the system doesn't hang :-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart4720624.bDgyU2f7Tv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHVDsihyrlCH22naMRAv1aAJwI1RdX79XZwXe87MT8ZAlM8kjP8QCeNq3X
2ookpj7p4E47YBne1NJjTMM=
=jWy1
-----END PGP SIGNATURE-----

--nextPart4720624.bDgyU2f7Tv--
