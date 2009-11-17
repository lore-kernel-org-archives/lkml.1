Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZKQIdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZKQIdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZKQIdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:33:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55569 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZKQIdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:33:18 -0500
Date: Tue, 17 Nov 2009 19:33:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: Shared i2c adapter locking
Message-Id: <20091117193313.b750804e.sfr@canb.auug.org.au>
In-Reply-To: <20091105150715.692b5200@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091029154317.651904b9@hyperion.delvare>
	<1256828976.2827.27.camel@achroite>
	<20091105141122.56b6b4f8@hyperion.delvare>
	<1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
	<20091105150715.692b5200@hyperion.delvare>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Nov_2009_19_33_13_+1100_.m=8U0Qtf1ssOISm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Nov_2009_19_33_13_+1100_.m=8U0Qtf1ssOISm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Thu, 5 Nov 2009 15:07:15 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> > Presumably this is meant for net-next-2.6, and you'll implement
>=20
> Actually I meant to push this to Linus immediately, through my i2c
> tree. This is essentially a no-op: the binary code will be the same as
> before the patch, so guaranteed to be safe, and this will solve
> conflicts in linux-next.

Any word on this?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Nov_2009_19_33_13_+1100_.m=8U0Qtf1ssOISm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksCX8kACgkQjjKRsyhoI8wh4wCgjjbOxLXKpfD46dgZudQt8F0G
GTUAoJJtBZcV1xUtVw8tP9A34tgBn5dw
=/oxd
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Nov_2009_19_33_13_+1100_.m=8U0Qtf1ssOISm--
