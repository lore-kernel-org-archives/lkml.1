Return-Path: <linux-kernel-owner+w=401wt.eu-S964997AbYBGVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbYBGVnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbYBGVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:43:08 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:47864 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932390AbYBGVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:43:05 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 00/45] 2.6.24-stable review
Date: Thu, 7 Feb 2008 23:41:42 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20080207204549.GA16389@suse.de>
In-Reply-To: <20080207204549.GA16389@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1296517.KZ3Na887li";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802072341.44001.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1296517.KZ3Na887li
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

07 =C5=9Eub 2008 Per tarihinde, Greg KH =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> This is the start of the stable review cycle for the 2.6.24.1 release.
> There are 45 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

If its possible could you please add [1] "mac80211: hardware scan rework" a=
nd [2] "mac80211: Restore rx.fc before every invocation of ieee80211_invoke=
_rx_handlers" into -stable too?

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3Dece8edddf067d21c4e5abfe3f1205da1588edbb2
[2] http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3D69f817b654d683265118188bbfb8bc0d8978cce6

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1296517.KZ3Na887li
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBHq3sXy7E6i0LKo6YRAotxAJ41FassYdOTPtlG7d2J0NkcGEqWngCfYNgy
lV1PQA/Jdr6YqWxuRPd0cTY=
=u82J
-----END PGP SIGNATURE-----

--nextPart1296517.KZ3Na887li--
