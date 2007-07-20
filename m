Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXGTXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXGTXWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbXGTXWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:22:36 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52224 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756477AbXGTXWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:22:36 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [GIT PULL][RESEND] Late KVM Updates for the 2.6.23 merge window
Date: Sat, 21 Jul 2007 02:21:30 +0300
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1184952728548-git-send-email-avi@qumranet.com>
In-Reply-To: <1184952728548-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1391966.mPjPlleK7Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707210221.34121.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1391966.mPjPlleK7Z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;=20

20 Tem 2007 Cum tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> Please pull from the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>=20
> to get the following changes:
>=20
> Avi Kivity (4):
>       KVM: MMU: Store nx bit for large page shadows
>       KVM: Fix memory slot management functions for guest smp
>       KVM: x86 emulator: implement rdmsr and wrmsr
>       KVM: MMU: Fix oopses with SLUB
>=20
> The last commit is new since the last pull request.

With Linus's latest git, shutting down a guest (fired with -smp 2 -m 512) s=
ometimes=20
ends up like [1], this occured as soon as qemu window closed.

[1] http://cekirdek.pardus.org.tr/~caglar/kvm/dmesg.latest

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1391966.mPjPlleK7Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGoUN+y7E6i0LKo6YRAp/xAJ9dsBhP93cfadSgMib2lNu6jUJCpwCgoC1I
M/fJ6Rp8U2dlcO+azzOq3/Y=
=Pt3Q
-----END PGP SIGNATURE-----

--nextPart1391966.mPjPlleK7Z--
