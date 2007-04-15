Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXDOQ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXDOQ0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXDOQ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:26:48 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:56028 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXDOQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:26:46 -0400
From: Marcus Better <marcus@better.se>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Date: Sun, 15 Apr 2007 18:26:33 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070414003808.GU5907@stusta.de> <1176515823.4807.7.camel@daplas>
In-Reply-To: <1176515823.4807.7.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4280644.u9WsuYudWA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704151826.33837.marcus@better.se>
X-DSPAM-Result: Spam
X-DSPAM-Processed: Sun Apr 15 18:26:43 2007
X-DSPAM-Confidence: 0.6816
X-DSPAM-Probability: 1.0000
X-DSPAM-Signature: 4622524365375966167465
X-DSPAM-Factors: 15,
	Content-Transfer-Encoding*quoted+printable, 0.99000,
	Content-Transfer-Encoding*printable, 0.99000,
	Content-Transfer-Encoding*quoted, 0.99000,
	Received*(unknown, 0.94439,
	Received*Sun, 0.83392,
	using, 0.20014,
	Yes, 0.20359,
	From*Marcus Better <marcus@better.se>, 0.23763,
	Date*Sun, 0.73683,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	but, 0.40000,
	Cc*vger.kernel.org>, 0.40000,
	Cc*linux+pm, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4280644.u9WsuYudWA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Antonino A. Daplas wrote:
> A screen with blinking green blocks implies that your display is in text
> mode, not in graphics mode.

Yes, it happens when I suspend from text mode.

> If the above does not work, also try
>
> acpi_sleep=3Ds3_bios,s3_mode

Will try, but I'm using "s2ram -f -a3" which should mean precisely the abov=
e=20
IIUC.

Marcus

--nextPart4280644.u9WsuYudWA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGIlI5XjXn6TzcAQkRAh3rAJ0exGxenHskFcXGy7wlhwUMzpb+cgCeLCYF
Stq7eJu8dHjPGfYHLyqYWBo=
=Wofn
-----END PGP SIGNATURE-----

--nextPart4280644.u9WsuYudWA--


