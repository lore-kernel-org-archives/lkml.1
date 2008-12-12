Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYLLWvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYLLWvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 17:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYLLWv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 17:51:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36368 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYLLWv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 17:51:26 -0500
Date: Sat, 13 Dec 2008 09:51:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] uio: make uio_info's name and version const
Message-Id: <20081213095118.b34aaf03.sfr@canb.auug.org.au>
In-Reply-To: <20081212104420.GA3084@local>
References: <20081212163041.7bc16261.sfr@canb.auug.org.au>
	<20081212104420.GA3084@local>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__13_Dec_2008_09_51_18_+1100_oaXI1AfMdR+Fmojr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__13_Dec_2008_09_51_18_+1100_oaXI1AfMdR+Fmojr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Fri, 12 Dec 2008 11:44:21 +0100 "Hans J. Koch" <hjk@linutronix.de> wrote:
>
> @Greg: Stephen's patch will only apply with some fuzz since you've
> accepted my portio patches in your queue. Below there's a version
> that should apply cleanly.

Thanks for that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__13_Dec_2008_09_51_18_+1100_oaXI1AfMdR+Fmojr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklC6uYACgkQjjKRsyhoI8wexACgunAqMYH6mOkknjbBTCnGs6gH
TEEAoLdNBNMnMKRhyXyEBvB/6rnORO4X
=j5W5
-----END PGP SIGNATURE-----

--Signature=_Sat__13_Dec_2008_09_51_18_+1100_oaXI1AfMdR+Fmojr--
