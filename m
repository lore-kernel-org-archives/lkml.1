Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBUQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBUQBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZBUQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:01:16 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49181 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZBUQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:01:15 -0500
Date: Sat, 21 Feb 2009 17:01:06 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/13] FSL eSDHC support
Message-ID: <20090221170106.53426838@mjolnir.ossman.eu>
In-Reply-To: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
References: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15573-1235232073-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15573-1235232073-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Feb 2009 20:32:28 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Hi all,
>=20
> Some updates for the eSDHC support:
>=20

I think the patches are coming along nicely. If we can just sort out
the accessors, then it should be ready for -next. It pokes around quite
a bit in the sdhci driver though, so I'd like it to stay there for one
cycle and (hopefully) be merged for 2.6.31.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15573-1235232073-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJUkACgkQ7b8eESbyJLgy2wCg8ohDidGvy5CliUpOHGMXf3Bk
HZwAn2CwEDbZBW9yPlSeFrugNfzuLruN
=bNS+
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15573-1235232073-0001-2--
