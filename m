Return-Path: <linux-kernel-owner+w=401wt.eu-S936964AbXGQX00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936964AbXGQX00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbXGQX0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:26:16 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42701 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757402AbXGQX0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:26:16 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Wed, 18 Jul 2007 02:25:27 +0300
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <11846910642166-git-send-email-avi@qumranet.com>
In-Reply-To: <11846910642166-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart98730659.PADB5yt7ui";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707180225.31160.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart98730659.PADB5yt7ui
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

17 Tem 2007 Sal tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> I fixed the issue with the previous patchset.  Please provide further
> feedback, or pull from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
>
> This contains kvm updates for the 2.6.23 merge window, including

After that commit (+appArmor patchset) any guest image hangs the system=20
completely as soon as started with kvm-29 userspace. Guest images works=20
with "qemu-kvm -hda X.img -m 512 -no-kvm" works as expected

I cannot provide any more information for now causes system freezes at all =
and=20
netconsole not works with ipw3945 (netconsole: eth1 doesn't support polling=
,=20
aborting) but tomorrow i'll try with cable.

If needed you can find .config and dmesg from [1], if anything else needed=
=20
please just say it...

[1] http://cekirdek.pardus.org.tr/~caglar/kvm/

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart98730659.PADB5yt7ui
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGnU/qy7E6i0LKo6YRAi0WAJ9wKy/CIcTwoa46FEztUZamyWinmQCgo+iI
Hpt7W9sAf9lPJGCOwg9zG5w=
=5Ms+
-----END PGP SIGNATURE-----

--nextPart98730659.PADB5yt7ui--
