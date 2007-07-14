Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXGNJXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXGNJXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXGNJXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:23:43 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38489 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbXGNJXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:23:42 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Surya <surya.prabhakar@gmail.com>
Subject: Re: [PATCH 0/12] drivers/isdn: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 12:23:23 +0300
User-Agent: KMail/1.9.7
Cc: kkeil@suse.de, linux-kernel@vger.kernel.org, surya.prabhakar@wipro.com
References: <b8c19edb0707140027y6f525dbew52b60128012007b2@mail.gmail.com>
In-Reply-To: <b8c19edb0707140027y6f525dbew52b60128012007b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1887587.ueV3vKvvrn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707141223.26704.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1887587.ueV3vKvvrn
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

14 Tem 2007 Cts tarihinde, Surya =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=B1:=
=20
>    Recently Keil has accepted few isdn related , pci_find_device
> cleanup patches, which are currently in -mm tree and would probably be
> in mainline kernel soon..
>
> look the below url shows a mail from karsten keil..
> http://marc.info/?l=3Dlinux-kernel&m=3D118029832418653&w=3D2
> Just make sure patch only the files not listed in the above patch..
> Also look at the kernel archives before you start patching , just to
> make sure somebody has not done it already..

Ahh, i was checked the -mm and isdn tree before sending these but somehow i=
=20
missed that one, thanks for the info and sorry for noise :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1887587.ueV3vKvvrn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGmJYOy7E6i0LKo6YRAs63AKCeZFQtZuTsfGm5oaiwLIC2FsTrswCfT3JM
c6r7Y4ZfH8DRzLd0jB5GDsE=
=Z4gP
-----END PGP SIGNATURE-----

--nextPart1887587.ueV3vKvvrn--
