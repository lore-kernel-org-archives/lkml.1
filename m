Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbXFOXhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbXFOXhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbXFOXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:37:23 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52268 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757582AbXFOXhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:37:21 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Interesting race between cpufreq_ondemand and snd_atiixp
Date: Sat, 16 Jun 2007 02:36:18 +0300
User-Agent: KMail/1.9.7
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk, tiwai@suse.de
References: <200706160233.47659.caglar@pardus.org.tr>
In-Reply-To: <200706160233.47659.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1760366.UEGl4Iu3Rm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706160236.18841.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1760366.UEGl4Iu3Rm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

16 Haz 2007 Cts tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
=2E..
> 3. echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		^^^ performance

Sorry for typo!

>    strace -o log -f -tttTTT mpg123 some.mp3
>
> works without a problem [full log @ 3]

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1760366.UEGl4Iu3Rm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGcyJyy7E6i0LKo6YRAlRUAKCfLMmTSiBw/rDGh8yZ0keQYacqMwCbBEvc
8/O/x7a89jzy2ZC8kgcxjHo=
=bp19
-----END PGP SIGNATURE-----

--nextPart1760366.UEGl4Iu3Rm--
