Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbXGTLjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbXGTLjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762110AbXGTLiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:38:54 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38424 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762083AbXGTLiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:38:52 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Fri, 20 Jul 2007 14:37:41 +0300
User-Agent: KMail/1.9.7
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181350.12919.caglar@pardus.org.tr> <46A048C2.20807@qumranet.com>
In-Reply-To: <46A048C2.20807@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26934774.FOLLaod1gg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707201437.48070.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26934774.FOLLaod1gg
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

20 Tem 2007 Cum tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> Turned out kvm and slub didn't like each other.  Please try applying
> these two patches, in order:
>=20
>   http://people.qumranet.com:8888/avi/kvm-late-fixes-rollup.patch
>   http://people.qumranet.com:8888/avi/kvm-vs-slub-fix.patch

Yep, these solved the problems, thanks!

Tested-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart26934774.FOLLaod1gg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGoJ6Ly7E6i0LKo6YRAkYIAJ9qgfwqnaV0GbvVyHbnUmhAboxaHgCdEQIy
CQAfsESvAj6P/YtyH89at+U=
=PZfk
-----END PGP SIGNATURE-----

--nextPart26934774.FOLLaod1gg--
