Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0CEM5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:57:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53254 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0CEM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:57:45 -0500
Date: Fri, 5 Mar 2010 13:57:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, akpm@osdl.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
	deprecation)
Message-ID: <20100305125732.GA23456@pengutronix.de>
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <20100303083010.GA22928@flint.arm.linux.org.uk> <20100305120746.646126b9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20100305120746.646126b9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Do any graphical environments even support the ancient user space
> pcmcica helper stuff ? I can't find any evidence they do but I realise
> Russell you get to deal with assorted crazy ARM embedded setups.

FWIW, a few months ago I searched the web for the warning about the usage of
the deprectaed pcmcia-ioctls. The vast majority came from Debian's discover
which seems to be no issue according to:

http://article.gmane.org/gmane.linux.kernel/885286

The other occurences I found have been fixed meanwhile. (I understand that I
might have missed rare cases this way)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuQ/7wACgkQD27XaX1/VRvhgQCcCSSFDerqWs5FFPiUSn5Gwml+
cJoAn2ZpPw+N25Yt2wjGCJRplR+wG0ZH
=jcec
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
