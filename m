Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXGRKvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXGRKvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbXGRKu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:50:59 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59294 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334AbXGRKu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:50:58 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Wed, 18 Jul 2007 13:50:09 +0300
User-Agent: KMail/1.9.7
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181309.11900.caglar@pardus.org.tr> <469DEC04.8000503@qumranet.com>
In-Reply-To: <469DEC04.8000503@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1609758.8fKxEM6Fks";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707181350.12919.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1609758.8fKxEM6Fks
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

18 Tem 2007 =C3=87ar tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> > http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole_wo_apparmor is the
> > vanilla one's netconsole output, by the way without apparmor patchset
> > system not hard freezes.
>
> This trace is certainly a kvm bug.  What guest are you running?  If it
> is free (and does not contain private information), can you post it
> somewhere for me to download?

I can reproduce same behaviour with fedora/opensuse/sled and pardus guests =
so=20
i guess this is not a image problem but also if you want, i can provide a=20
mini-pardus image for you to try?

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1609758.8fKxEM6Fks
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnfBky7E6i0LKo6YRAjIiAJ9KYQhsqsJOZfHe4GByWEzSfPHg/QCfVHsm
ef+ydrA81dG7+uIxJ2DYbyM=
=hJfI
-----END PGP SIGNATURE-----

--nextPart1609758.8fKxEM6Fks--
