Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZDQQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZDQQXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759158AbZDQQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:23:31 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:37127 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400AbZDQQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:23:30 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
Date: Fri, 17 Apr 2009 18:23:13 +0200
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5710256.augzhveVOz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904171823.20897.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5710256.augzhveVOz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12836
> Subject		: 2.6.29-rc breaks STD using Intel 945
> Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
> Date		: 2009-03-04 19:20 (34 days old)
> References	: http://marc.info/?l=linux-kernel&m=123619451406192&w=4

Looks like this is fixed since 2.6.30-rc1.

Eike

--nextPart5710256.augzhveVOz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknorPgACgkQXKSJPmm5/E5S2gCggsu0e9N7V91l2q0D1jUODhKs
MgUAoIfck2dKs4e1qnDk20Xbs6WxVhMp
=GhPw
-----END PGP SIGNATURE-----

--nextPart5710256.augzhveVOz--
