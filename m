Return-Path: <linux-kernel-owner+w=401wt.eu-S1032372AbXEHV3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032372AbXEHV3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032365AbXEHV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:29:05 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57804 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031838AbXEHV3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:29:01 -0400
From: "=?iso-8859-9?q?S=2E=C7a=F0lar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Date: Wed, 9 May 2007 00:28:34 +0300
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>
References: <653FFBB4508B9042B5D43DC9E18836F55DF62B@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55DF62B@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1503193.KA5DkEojCh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705090028.34969.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1503193.KA5DkEojCh
Content-Type: text/plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

09 May 2007 =C7ar tarihinde, Pallipadi, Venkatesh =FEunlar=FD yazm=FD=FEt=
=FD:=20
> That's good news :-).
>
> Can you send me the full dmesg with the 5 patches and also the config file
> you are using. Also, did you try these patches against 2.6.21-vanilla or
> recent git?

I'm trying these on top of 2.6.21.1 + CFS-v11 and with some other patches=20
(bootsplash + apparmor + swap prefetch + your ondemand timer patch)

You can find config.gz and full dmesg at [1]=20

[1] http://cekirdek.pardus.org.tr/~caglar/hpet/
=2D-=20
S.=C7a=F0lar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1503193.KA5DkEojCh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGQOuCy7E6i0LKo6YRAnOeAKCeZIUXax3+rcyJql7TOxkjyZ3DcwCgup5E
YU3XxvFul8w0MPe3iSZVJq4=
=ELLI
-----END PGP SIGNATURE-----

--nextPart1503193.KA5DkEojCh--
