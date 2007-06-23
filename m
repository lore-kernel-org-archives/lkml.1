Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXFWQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXFWQ7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXFWQ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:58:58 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57997 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755252AbXFWQ65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:58:57 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] audit: fix oops removing watch if audit disabled
Date: Sat, 23 Jun 2007 19:58:32 +0300
User-Agent: KMail/1.9.7
Cc: Tony Jones <tonyj@suse.de>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20070620223820.GA16416@suse.de> <20070623095153.279c1194.akpm@linux-foundation.org>
In-Reply-To: <20070623095153.279c1194.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24139546.4GOUkIM0Jj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706231958.32313.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24139546.4GOUkIM0Jj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

23 Haz 2007 Cts tarihinde, Andrew Morton =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9F=
t=C4=B1:=20
> This looks like 2.6.22 material to me.
>
> Question is: is it also 2.6.21.x material?

I even can reproduce same oops with 2.6.18 :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart24139546.4GOUkIM0Jj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGfVE4y7E6i0LKo6YRAo/QAKDWeiIS3djIZcU2ex6XvCZM33fjGgCeJ7/m
UsjIP1agdO9hR5gbVgjYyjg=
=oQL1
-----END PGP SIGNATURE-----

--nextPart24139546.4GOUkIM0Jj--
