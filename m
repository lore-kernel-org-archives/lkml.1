Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYL2WT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYL2WT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYL2WTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:19:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54018 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbYL2WTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:19:49 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA Dreamcast
Date: Mon, 29 Dec 2008 17:19:42 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
References: <1230578246.6496.25.camel@localhost.localdomain> <20081229214634.GA27064@uranus.ravnborg.org> <1230589073.6496.30.camel@localhost.localdomain>
In-Reply-To: <1230589073.6496.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1844194.ARYGyQ4zTa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812291719.47754.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1844194.ARYGyQ4zTa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 17:17:53 Adrian McMenamin wrote:
> On Mon, 2008-12-29 at 22:46 +0100, Sam Ravnborg wrote:
> > Look for an increase in section mismatch warning or try to
> > build with:
> > make CONFIG_DEBUG_SECTION_MISMATCH=3Dy
>
> Just rebuilt the whole thing from scratch with that turned on and no
> extra warnings at all.

regardless, please add the aforementioned wrapping.  this comes up from tim=
e=20
to time in various configurations.
=2Dmike

--nextPart1844194.ARYGyQ4zTa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWU0DAAoJEEFjO5/oN/WB/jEQAMPltsi2yYhWiIs+RL/Vn7o6
Zxf5aAMX1SkKCou7qErrPMvYJKZTXuIUXBKBTLFIdDsMALsiH6vy+Ju+FpWTk8RR
V5QuskwMe3rrxgF3Mece/zWmPZl33L1o9OpW0MJZhQnz3mFCl/KsU3wQiENKMeDr
8/bcjZuVEwRid+xzJzA5KREEytA5slnGOQ4exuN50UYXHkVcpD1J/XeW7UWjY3dk
IrgWpTdSJCyrbpW2gNmOKXEeMh05VvwKz66u59r+KMDAMKbyHhYl0Bc3bOpZXVvR
Ytvy7fxG1qUO9Yu+iM0MS5ZIsNMEqgRvKIF87eOYlGKYN3X0XwRVBpeDpNfI3nS+
Q3cKkM1ucRB3Yi5snpmquVO6JAYe2br0p/Hk+P+DQMIVMKmlWjf9mfQGOww0+MmM
Fpa4sQu/feeY7MRqmMl+N6KIBzcxRQoiZDAIa3W45WIwAaYljBXjtFzBg58P2aMS
cvSIhoRnR/6Yqb79ALbXdVTq0OUwlCu432GanQhGdx2v3IDvMQHIfKmT89+8DK8A
Yq3kH2z22sn1u4Z0oNWBF66M6Cjaz+Qs8vZRmyBN8rzaGkrP/DO++JgjsWYfBGK8
jSKFfV6w+Tz7iXfiCRxYgmBR/eJk1X/tDt8ry3hYZtPvs27l9j9bRkl0W9XaDLBx
F15Om2/dhBjCpe9+Ik+0
=Js/w
-----END PGP SIGNATURE-----

--nextPart1844194.ARYGyQ4zTa--
