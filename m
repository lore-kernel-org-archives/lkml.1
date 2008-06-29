Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYF2QvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYF2QvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYF2Quh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:50:37 -0400
Received: from server.drzeus.cx ([85.8.24.28]:39469 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755052AbYF2Qtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:49:46 -0400
Date: Sun, 29 Jun 2008 18:49:38 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-embedded@vger.kernel.org, shannon.nelson@intel.com,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 6/6] Atmel MCI: Driver for Atmel on-chip MMC
 controllers
Message-ID: <20080629184938.7e3d7cd6@mjolnir.drzeus.cx>
In-Reply-To: <20080628153144.128faa7b@hskinnemo-gx745.norway.atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-7-git-send-email-haavard.skinnemoen@atmel.com>
	<20080627211014.0e80db04@siona.local>
	<20080627215627.5d75639c@mjolnir.drzeus.cx>
	<20080628144313.353bbf18@hskinnemo-gx745.norway.atmel.com>
	<20080628153144.128faa7b@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-28712-1214757562-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-28712-1214757562-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Jun 2008 15:31:44 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > Tests 7 and 9 are not supported by the card, so I can't do much about
> > it except go through all the cards I have available and see if one of
> > them supports this test.
>=20
> Turns out none of my 12 cards of various brands and models support this
> test. Do you know some specific model I can try?
>=20

Of the set I have here, only one supported partial writes. A prototype
samsung MMC 4.2 card. It has the markings "MM8GH04GNACA-9A" on it. A
quick google doesn't turn up anything, but some other new Samsung MMC
card might have good odds.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-28712-1214757562-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhnvSYACgkQ7b8eESbyJLj0zwCgqm48k8rhcgo/iCYOASeJt51v
8dAAnjnlX5aJvocFwA5IXSo8ZER1Ur1Y
=Jea+
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-28712-1214757562-0001-2--
