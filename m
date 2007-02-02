Return-Path: <linux-kernel-owner+w=401wt.eu-S1423005AbXBAUyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423005AbXBAUyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423006AbXBAUyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:54:13 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:41064 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423005AbXBAUyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:54:12 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.20-rc7
Date: Fri, 2 Feb 2007 22:52:22 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Peter Anvin <hpa@zytor.com>, Mark Huang <mlhuang@cs.princeton.edu>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2032648.S0KZ8E6rFl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702022252.26317.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2032648.S0KZ8E6rFl
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

01 =C5=9Eub 2007 Per tarihinde, Linus Torvalds =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> I've added some initramfs people to the Cc: in case somebody has better
> ideas, but in the absense of that, it really would be good to do that
> bisection. Also, you might want to double-check that your cpio actually
> generates a good initramfs image (it that it's not some user-mode upgrade
> that caused it to stop working).

I started bisect with 2.6.19 and ended up with 2.6.20-rc7 and every step=20
worked without a problem with problematic initramfs script, so i think that=
=20
was a compilation failure or something else but currently 2.6.20-rc7 works=
=20
without a problem, so please ignore that one, sorry for noise...

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2032648.S0KZ8E6rFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFw6SKy7E6i0LKo6YRApf5AJ9zo8rBBeDrALVVCB5lmJ9DhhG6EACgg8wh
xYbhxwtQQW25faLnkc6ALAs=
=aGaJ
-----END PGP SIGNATURE-----

--nextPart2032648.S0KZ8E6rFl--
