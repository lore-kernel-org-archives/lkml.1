Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXIDQLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXIDQLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXIDQLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:11:17 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:48986 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbXIDQLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:11:16 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc5
Date: Tue, 4 Sep 2007 19:10:59 +0300
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1844897.vOC4sNci0f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709041911.03442.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1844897.vOC4sNci0f
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

01 Eyl 2007 Cts tarihinde, Linus Torvalds =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> So have fun, give it a go, and expect a quiet week next week.

After upgrading -rc5 (i'm currently using linus's latest git + appArmor and=
=20
bootsplash patchset) my CD/DVD-ROM suddenly disappeared :).=20

caglar@zangetsu ~ $ diff -u rc4 rc5 | grep cd-rom -i
=2DSep  3 11:30:33 localhost kernel: [   19.328120] scsi 4:0:0:0: CD-ROM   =
        =20
MATSHITA DVD-RAM UJ-851S  1.50 PQ: 0 ANSI: 5
=2DSep  3 11:30:33 localhost kernel: [   21.258819] Uniform CD-ROM driver=20
Revision: 3.20
=2DSep  3 11:30:33 localhost kernel: [   21.258873] sr 4:0:0:0: Attached sc=
si=20
CD-ROM sr0

You can find the logs and config from [1], i'm on a vacation with unstable=
=20
network connection so i may not respond fast enough and i don't have enough=
=20
time to bisect for a while :(.

[1] http://cekirdek.pardus.org.tr/~caglar/kernel/

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1844897.vOC4sNci0f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBG3YOXy7E6i0LKo6YRAv+4AJ9JIi5lWMyHvZiM4TsL9XsM5Uj3hgCfQOL1
flCJzFkWpfWj+3Phc5qtbdY=
=Idl0
-----END PGP SIGNATURE-----

--nextPart1844897.vOC4sNci0f--
