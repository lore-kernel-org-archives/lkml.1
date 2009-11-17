Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZKQU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZKQU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZKQU7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:59:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50188 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZKQU7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:59:17 -0500
Date: Wed, 18 Nov 2009 07:59:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: Shared i2c adapter locking
Message-Id: <20091118075917.9ac0248c.sfr@canb.auug.org.au>
In-Reply-To: <20091117103554.03971b2f@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091029154317.651904b9@hyperion.delvare>
	<1256828976.2827.27.camel@achroite>
	<20091105141122.56b6b4f8@hyperion.delvare>
	<1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
	<20091105150715.692b5200@hyperion.delvare>
	<20091117193313.b750804e.sfr@canb.auug.org.au>
	<20091117103554.03971b2f@hyperion.delvare>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Nov_2009_07_59_17_+1100_4c.670WErxsQBW.b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Nov_2009_07_59_17_+1100_4c.670WErxsQBW.b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 17 Nov 2009 10:35:54 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> Haven't you read this:
> http://www.spinics.net/lists/linux-next/msg07839.html
>=20
> and the 3 following posts?

Somehow I missed that, sorry :-(

> If you did and something is still not clear, please let me know. My
> understanding is that the action token is in David's hands now.

OK, I will await developments :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_Nov_2009_07_59_17_+1100_4c.670WErxsQBW.b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksDDqUACgkQjjKRsyhoI8ye2wCePBRJDwGffoAbkqiiTpm0cyFr
odwAn1zxSq7OJHHQ6zr6QdCUc1ZB8P4S
=wZxa
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Nov_2009_07_59_17_+1100_4c.670WErxsQBW.b--
