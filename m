Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXGRKSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXGRKSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbXGRKSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:18:39 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:56532 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754016AbXGRKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:18:38 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Wed, 18 Jul 2007 13:17:53 +0300
User-Agent: KMail/1.9.7
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <11846910642166-git-send-email-avi@qumranet.com> <469DDEF7.7020107@qumranet.com> <200707181309.11900.caglar@pardus.org.tr>
In-Reply-To: <200707181309.11900.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9795801.R4KvOKOIbG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707181317.53468.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9795801.R4KvOKOIbG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

18 Tem 2007 =C3=87ar tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 y=
azm=C4=B1=C5=9Ft=C4=B1:=20
> http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole_wo_apparmor is the
> vanilla one's netconsole output, by the way without apparmor patchset
> system not hard freezes.

Ahhh netconsole cannot grab whole output, full log from kern.log follows [1]

[1] http://cekirdek.pardus.org.tr/~caglar/kvm/kern.log

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart9795801.R4KvOKOIbG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnejRy7E6i0LKo6YRArDUAKCfnyq/Ub5UbPn+IDB+pMN0l+MrHwCgojpt
urToyL+Tmq6cIo7damVU84E=
=imvA
-----END PGP SIGNATURE-----

--nextPart9795801.R4KvOKOIbG--
