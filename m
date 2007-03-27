Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXC0Qxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXC0Qxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXC0Qxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:53:54 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:54726 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbXC0Qxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:53:53 -0400
From: Marcus Better <marcus@better.se>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
Date: Tue, 27 Mar 2007 18:53:40 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <200703271000.05341.marcus@better.se> <m13b3qzumf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b3qzumf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1376103.W5CeNlsDzv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703271853.43764.marcus@better.se>
X-DSPAM-Result: Spam
X-DSPAM-Processed: Tue Mar 27 18:53:51 2007
X-DSPAM-Confidence: 0.7818
X-DSPAM-Probability: 1.0000
X-DSPAM-Signature: 46094c1f744011883718420
X-DSPAM-Factors: 15,
	Content-Transfer-Encoding*quoted+printable, 0.99000,
	Content-Transfer-Encoding*printable, 0.99000,
	Content-Transfer-Encoding*quoted, 0.99000,
	Received*(unknown, 0.94439,
	From*Marcus Better <marcus@better.se>, 0.22703,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	works+Marcus, 0.40000,
	could, 0.40000,
	Cc*vger.kernel.org>, 0.40000,
	I+tried, 0.40000,
	References*<200703271000.05341.marcus+better.se>, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	yellow+"Linux!, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1376103.W5CeNlsDzv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Eric W. Biederman wrote:

> >> Patch      : http://lkml.org/lkml/2007/3/24/136

> Marcus any chance I could see an oops?

I didn't see anything, it froze with the yellow "Linux!" sign. Any idea how=
 to=20
get a oops?

> Or you could try the patch I=20
> previously posted when debugging this with Thomas.

Do you mean the one referenced above? I tried it [1] and it works.

Marcus

[1] http://permalink.gmane.org/gmane.linux.kernel/509299

--nextPart1376103.W5CeNlsDzv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGCUwXXjXn6TzcAQkRAhRAAJ9PRuUul2gVzQoR+biLsaegahJPiwCgwkTL
06RenARvgMKTwd+WdWMvWPk=
=4xyB
-----END PGP SIGNATURE-----

--nextPart1376103.W5CeNlsDzv--


