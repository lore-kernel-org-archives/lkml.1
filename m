Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZGNNgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZGNNgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZGNNgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:36:15 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49435 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbZGNNgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:36:15 -0400
Date: Tue, 14 Jul 2009 15:36:01 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       Pavel Pisa <ppisa@pikron.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>, Ben Dooks <ben@fluff.org>,
       saschasommer@freenet.de, avorontsov@ru.mvista.com,
       Alex Dubov <oakad@yahoo.com>, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: New MMC maintainer needed
Message-ID: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-6573-1247578570-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-6573-1247578570-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I'm afraid the time has come for me to step down as maintainer for the
MMC/SD/SDIO subsystem and for someone else to take over the rudder. It
is no secret that I haven't been able to give the maintainer role the
resources it required, and as a result it has gone from being a fun
hobby to a burdensome chore. I was hoping it was a temporary slump, but
this has been the norm for over a year now, so it's time for me to
throw in the towel.

I don't have any clear nominees for a replacement, but if you feel that
you are in a position to take over the maintainer role then please
raise your hand.

I only have a few patches in my queue right now and I can push those
off to Linus before I quit. There are however a lot of unhandled
messages that need attention. I can provide a list once a successor has
been named.

I realise that you have put a lot of time and effort into the patches
you send me and I am truly sorry that I haven't been able to handle
them better. Hopefully me stepping down means that we get someone who
can actually take care of everything in a timely manner.

I haven't decided what to do with the sdhci maintainership yet. Right
now I only know I need a break and freeing myself from the MMC
maintainer role is the first step. Hopefully I can return as a
developer in the future.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-6573-1247578570-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpcicoACgkQ7b8eESbyJLij2QCfQKe9XJvFsd/oUoF5/qIVFAoS
hugAoJOIL4kmFHavWxEKpnt8C5gAuHFv
=yhTF
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-6573-1247578570-0001-2--
