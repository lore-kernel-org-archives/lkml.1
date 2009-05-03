Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZECT36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZECT36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZECT3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:29:49 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40164 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZECT3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:29:48 -0400
Date: Sun, 3 May 2009 21:29:44 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Garrett D'Amore" <garrett@damore.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, sdhci-devel@lists.ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Sdhci-devel] SDHCI driver runnining in aspire one, allows to
 write to R/O SD cards
Message-ID: <20090503212944.214d7137@mjolnir.ossman.eu>
In-Reply-To: <49F5F57D.3010700@damore.org>
References: <1240219764.13640.5.camel@maxim-laptop>
	<49ED0865.9030603@gmail.com>
	<1240524632.20871.0.camel@maxim-laptop>
	<1240759276.10972.0.camel@maxim-laptop>
	<49F5F57D.3010700@damore.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10373-1241378986-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10373-1241378986-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2009 11:12:13 -0700
Garrett D'Amore <garrett@damore.org> wrote:

> As an extra data point, my sdhost driver in OpenSolaris works fine on=20
> the AA1.. it does see that the cards are locked, and refuses to allow=20
> them to be mounted read/write.
>=20
> This leads me to believe that the original linux problem is one of two=20
> things:
>=20
> * either a bug in the linux code, or
> * busted circuit/hardware on a specific unit (i.e. a damaged unit)
>=20

I don't suppose you could try a Linux LiveCD to determine if your AA1
has the same issue under Linux?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10373-1241378986-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn98KoACgkQ7b8eESbyJLglhACfTHxXY7pD/fSw/EXjuR4Ru/Px
HbIAn1ueerq08j4kP9vShhkxoqUsaW9S
=DwOC
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10373-1241378986-0001-2--
