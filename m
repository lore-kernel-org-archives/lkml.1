Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbXDQLyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbXDQLyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDQLyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:54:31 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:59587 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXDQLyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:54:22 -0400
From: Marcus Better <marcus@better.se>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Date: Tue, 17 Apr 2007 13:54:01 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704171017.07012.marcus@better.se> <1176802076.6227.2.camel@daplas>
In-Reply-To: <1176802076.6227.2.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1769455.t1OSbY4cIj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704171354.06542.marcus@better.se>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Apr 17 13:54:17 2007
X-DSPAM-Confidence: 0.6075
X-DSPAM-Probability: 0.0248
X-DSPAM-Signature: 4624b56965371975720330
X-DSPAM-Factors: 27,
	Received*(unknown, 0.94439,
	as+I, 0.12045,
	Yes, 0.20359,
	as, 0.20688,
	as, 0.20688,
	From*Marcus Better <marcus@better.se>, 0.24071,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Received*(Postfix), 0.67386,
	Cc*vger.kernel.org>, 0.40000,
	Cc*linux+pm, 0.40000,
	Message-Id*<200704171354.06542.marcus, 0.40000,
	Date*Apr, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	Received*Tue, 0.40000,
	Received*Tue, 0.40000,
	Cc*Adrian+Bunk, 0.40000,
	Received*9332C205CCA, 0.40000,
	Date*2007+13, 0.40000,
	Works!+>, 0.40000,
	Received*ESMTP, 0.40000,
	Received*ESMTP, 0.40000,
	Content-Disposition*inline, 0.40000,
	Cc*stusta.de>, 0.40000,
	a3+m, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1769455.t1OSbY4cIj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> > s2ram -f -a3 -m: Works!
>
> Thanks.  Should we consider this regression resolved?

Yes, as far as I am concerned...

Marcus

--nextPart1769455.t1OSbY4cIj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJLVeXjXn6TzcAQkRAsXXAJ4lkyhKMKeAUWk+gdfDmYmmgjCIIgCfZ293
NDDgP5WhKmNG+U36AR6lsdw=
=WhK+
-----END PGP SIGNATURE-----

--nextPart1769455.t1OSbY4cIj--


