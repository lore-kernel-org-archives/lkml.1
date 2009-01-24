Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZAXMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZAXMYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZAXMXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:23:55 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46006 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZAXMXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:23:54 -0500
Date: Sat, 24 Jan 2009 13:23:42 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Message-ID: <20090124132342.0086e6ec@mjolnir.drzeus.cx>
In-Reply-To: <200901121150.32714.wolfgang.mues@auerswald.de>
References: <20090108092407.GA6108@console-pimps.org>
	<200901121150.32714.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-2779-1232799829-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-2779-1232799829-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I just want to throw my .02 SEK in here.

In essence, I agree with both of you. :)

We should do what we can to force vendors to follow standards. But as
Wolfgang says, punishing their users rarely gets the job done.
Especially when the user has no idea that the card is to blame.

My general approach in these conditions is to work around the bugs as
much as possible (as long as those workarounds doesn't make life
difficult for compliant cards), and try to shame the vendor by logging
buggy cards.

So Wolfgang, if you could separate out your workarounds to independent
patches and see what can be done to complain in dmesg about hardware
bugs (without flooding dmesg).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-2779-1232799829-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEUEARECAAYFAkl7CFUACgkQ7b8eESbyJLirUQCXWyYropTx/rQQ83PuaD95O6aO
bwCg6rskT/lNqeb0dnIwEssHkYri97U=
=ZqzP
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-2779-1232799829-0001-2--
