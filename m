Return-Path: <linux-kernel-owner+w=401wt.eu-S1032463AbXENL6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032463AbXENL6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031543AbXENLs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:48:59 -0400
Received: from lugor.de ([212.112.242.222]:34630 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1032208AbXENLs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:48:58 -0400
From: Christian Hesse <mail@earthworm.de>
To: linux-kernel@vger.kernel.org
Subject: dm(-crypt) and /dev/disk/by-label/
Date: Mon, 14 May 2007 13:48:42 +0200
User-Agent: KMail/1.9.6
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1521833.tlyvhjmkbA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705141348.48099.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Mon, 14 May 2007 13:48:55 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1521833.tlyvhjmkbA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello everybody,

If this is the wrong place to ask, please tell me where to ask instead.

I have ext3 filesystems with labels on devicemapper crypted devices. These =
do=20
not show up in /dev/disk/by-label/, in contrast to filesystems of my "real"=
=20
partitions. Is this the expected behaviour or what could go wrong?
=2D-=20
Regards,
Chris

--nextPart1521833.tlyvhjmkbA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGSEyblZfG2c8gdSURAjp1AKCvZ26YEU531s3uboo5swUBLiQWdQCeK7ed
8XCcrQOmkxlY8FufbNw3ulA=
=r1KA
-----END PGP SIGNATURE-----

--nextPart1521833.tlyvhjmkbA--
