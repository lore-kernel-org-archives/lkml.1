Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205Ab0AKH4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0AKH4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 02:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444Ab0AKH4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 02:56:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51949 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0AKH4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 02:56:52 -0500
Date: Mon, 11 Jan 2010 18:56:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, hawk@comx.dk, hadi@cyberus.ca
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100111185645.a66c6c8a.sfr@canb.auug.org.au>
In-Reply-To: <20100110.225055.167520274.davem@davemloft.net>
References: <20100111133109.a191ee64.sfr@canb.auug.org.au>
	<20100110.225055.167520274.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Jan_2010_18_56_45_+1100_FCvLUpN6y=Y5Iowp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Jan_2010_18_56_45_+1100_FCvLUpN6y=Y5Iowp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 10 Jan 2010 22:50:55 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> That latter commit is specially in the net-next-2.6 tree not the
> net-2.6 tree.

What you call "net-next-2.6", I have always called "net".  What you call
"net-2.6", I have always called "net-current".  Would you like me to
change the names?

> I'll merge net-2.6 into net-next-2.6 to resolve this, thanks!

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Jan_2010_18_56_45_+1100_FCvLUpN6y=Y5Iowp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktK2b0ACgkQjjKRsyhoI8wb9gCgrW4lQuWPRFEo4l/rnS4PFr+G
InEAnRtMnUgl/Fb3rOMv+sW/97DTvnsq
=J45b
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Jan_2010_18_56_45_+1100_FCvLUpN6y=Y5Iowp--
