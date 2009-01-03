Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZACKVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZACKVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZACKVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:21:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51545 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZACKVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:21:06 -0500
Date: Sat, 3 Jan 2009 21:20:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: git-pull request for tip/cpus4096
Message-Id: <20090103212056.93edfc31.sfr@canb.auug.org.au>
In-Reply-To: <200901032033.25087.rusty@rustcorp.com.au>
References: <495E4837.8090600@sgi.com>
	<200901031631.47818.rusty@rustcorp.com.au>
	<20090103171838.0610d443.sfr@canb.auug.org.au>
	<200901032033.25087.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Jan_2009_21_20_56_+1100_/R/O8d2g7v56/Yw+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Jan_2009_21_20_56_+1100_/R/O8d2g7v56/Yw+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Sat, 3 Jan 2009 20:33:24 +1030 Rusty Russell <rusty@rustcorp.com.au> wro=
te:
>
> BTW, do you send mail automagically when something breaks, or does one ha=
ve
> to check the web page?

The infrastructure (kissb) doesn't have a notification facility but I
might suggest it to Michael.  Sometimes (when I have time) I check out
the results and report anything interesting.  Otherwise, I expect
interested people will check every now and then.

Maybe more publicity is needed (though I do mention it in the daily
release announcements).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_Jan_2009_21_20_56_+1100_/R/O8d2g7v56/Yw+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklfPAgACgkQjjKRsyhoI8y/UQCfXP6tFHzZoRAvLf8V9Wz9fAT1
F3oAoIEqPbN77dYsLN9hHPAaNEJeRR1f
=Q99y
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Jan_2009_21_20_56_+1100_/R/O8d2g7v56/Yw+--
