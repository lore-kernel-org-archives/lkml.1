Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZKGCf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZKGCf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZKGCf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:35:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44922 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZKGCf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:35:56 -0500
Date: Sat, 7 Nov 2009 13:35:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristoffer@gaisler.com
Subject: Re: linux-next: sparc tree build failure
Message-Id: <20091107133556.3731592c.sfr@canb.auug.org.au>
In-Reply-To: <20091106.002651.21006753.davem@davemloft.net>
References: <20091106180248.7a6aa9ba.sfr@canb.auug.org.au>
	<20091106.001930.121210402.davem@davemloft.net>
	<20091106.002651.21006753.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__7_Nov_2009_13_35_56_+1100_aNRvTbHYo9ssllKm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Nov_2009_13_35_56_+1100_aNRvTbHYo9ssllKm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 06 Nov 2009 00:26:51 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Stephen, can you let me know if this takes care of everything?

Sorry, sleep intervened :-)

That patch fixes the build of the .o (I didn't do the link).

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Nov_2009_13_35_56_+1100_aNRvTbHYo9ssllKm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr03QwACgkQjjKRsyhoI8ztXQCfT6FcNMmQUhKxqAEEO6A9OVa1
Cs8An0Vt6FrRET4V5jCKkyrlaruW7QFC
=MM69
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Nov_2009_13_35_56_+1100_aNRvTbHYo9ssllKm--
